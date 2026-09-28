# /// script
# dependencies = [
#     "altair==6.3.0",
#     "loguru==0.7.3",
#     "marimo",
#     "numpy==2.5.3",
#     "polars==1.44.2",
#     "pydantic==2.13.5",
# ]
# requires-python = ">=3.13"
# ///

import marimo

__generated_with = "0.25.0"
app = marimo.App(width="medium")


@app.cell(hide_code=True)
def _():
    import marimo as mo
    import polars.selectors as cs
    from loguru import logger
    import polars as pl
    import altair as alt
    from pydantic.dataclasses import dataclass
    from pydantic import Field
    import numpy as np

    return Field, alt, cs, dataclass, mo, np, pl


@app.cell
def _(
    applications_per_week,
    hr,
    interview_pass,
    mo,
    n_applications,
    n_candidates,
    n_interviews,
    relevance,
    relevance_sigma,
    team,
):
    mo.vstack(
        [
            n_candidates,
            relevance,
            relevance_sigma,
            hr,
            team,
            interview_pass,
            n_interviews,
            n_applications,
            applications_per_week,
        ]
    )
    return


@app.cell(hide_code=True)
def _(mo):
    n_candidates = mo.ui.slider(
        start=1,
        stop=1000,
        step=1,
        value=100,
        label="Number of candidates `N`:",
        include_input=True,
    )
    relevance = mo.ui.slider(
        start=0,
        stop=1,
        step=0.01,
        value=0.9,
        label="Median relevance `R`:",
        include_input=True,
    )
    relevance_sigma = mo.ui.slider(
        start=0.001,
        stop=1,
        step=0.001,
        value=0.1,
        label="Std of relevance:",
        include_input=True,
    )
    hr = mo.ui.slider(
        start=0,
        stop=1,
        step=0.01,
        value=0.9,
        label="HR pass threshold `H`:",
        include_input=True,
    )
    team = mo.ui.slider(
        start=0,
        stop=1,
        step=0.01,
        value=0.9,
        label="Team check pass threshold `H`:",
        include_input=True,
    )
    interview_pass = mo.ui.slider(
        start=0,
        stop=1.0,
        step=0.1,
        value=0.8,
        label="Interview pass check `I`:",
        include_input=True,
    )
    n_interviews = mo.ui.slider(
        start=0,
        stop=10,
        step=1,
        value=2,
        label="Number of independent interviews `n`:",
        include_input=True,
    )
    n_applications = mo.ui.slider(
        start=0,
        stop=1000,
        step=1,
        value=100,
        label="Total number of applications `N`:",
        include_input=True,
    )
    n_runs = mo.ui.slider(
        start=1,
        stop=100,
        step=1,
        value=20,
        label="Number of job application simulation runs",
        include_input=True,
    )
    applications_per_week = mo.ui.slider(
        start=0.5,
        stop=100,
        step=0.5,
        value=7,
        label="Applying for a new position ... times per week",
        include_input=True,
    )
    return (
        applications_per_week,
        hr,
        interview_pass,
        n_applications,
        n_candidates,
        n_interviews,
        n_runs,
        relevance,
        relevance_sigma,
        team,
    )


@app.cell(hide_code=True)
def _(
    Field,
    dataclass,
    hr,
    interview_pass,
    n_applications,
    n_candidates,
    n_interviews,
    n_runs,
    np,
    pl,
    relevance,
    relevance_sigma,
    team,
):
    @dataclass
    class JobInterviewConfig:
        n_candidates: int = Field(
            default=n_candidates.value,
            title="Number of candidates",
            ge=n_candidates.start,
            le=n_candidates.stop,
        )
        relevance: float = Field(
            default=relevance.value,
            title="Relevance to the position",
            ge=0.0,
            le=1.0,
        )
        relevance_std: float = Field(
            default=relevance_sigma.value,
            title="Relevance to the position",
            gt=0.0,
        )
        hr: float = Field(
            default=hr.value, title="HR pass threshold", ge=0.0, le=1.0
        )
        team: float = Field(
            default=team.value,
            title="Team check pass threshold",
            ge=0.0,
            le=1.0,
        )
        interview_pass: float = Field(
            default=interview_pass.value,
            title="Interview pass check",
            ge=0.0,
            le=1.0,
        )
        n_interviews: int = Field(
            default=n_interviews.value,
            ge=n_interviews.start,
            le=n_interviews.stop,
        )

    def left_half_truncated(size, *, mu=1.0, sigma=1.0, lo=0.0):
        rng = np.random.default_rng()
        n = size
        out = np.empty(0)
        while out.size < n:
            s = mu - np.abs(rng.normal(0, sigma, size=2 * n))
            out = np.concatenate([out, s[s >= lo]])
        return out[:n]

    def sample_interview(
        config: JobInterviewConfig, interview_id: int | None = None
    ) -> pl.DataFrame:
        size = config.n_candidates

        data = {
            "relevance": left_half_truncated(
                size=size, sigma=config.relevance_std
            ),
            "hr": np.random.uniform(size=size),
            "team": np.random.uniform(size=size),
        } | {
            f"interview_pass_{i}": np.random.uniform(size=size)
            for i in range(config.n_interviews)
        }
        data = {
            col: pl.Series(values=value.tolist()).alias(col)
            for col, value in data.items()
        }

        return pl.DataFrame(list(data.values())).with_columns(
            interview_id=pl.lit(interview_id),
            check_hr=pl.col("hr") < config.hr,
            check_team=pl.col("team") < config.team,
            check_interviews=pl.all_horizontal(
                pl.col(f"interview_pass_{i}") < config.interview_pass
                for i in range(config.n_interviews)
            ),
        )

    def summarize_application(df: pl.DataFrame) -> pl.DataFrame:
        return (
            df.group_by("interview_id")
            .agg(
                n_hr_pass=pl.col("check_hr").sum(),
                n_team_pass=pl.col("check_team").sum(),
                n_interview_pass=pl.col("check_interviews").sum(),
                n_pass=pl.all_horizontal(
                    pl.col("check_hr"),
                    pl.col("check_team"),
                    pl.col("check_interviews"),
                ).sum(),
            )
            .with_columns(
                p_pass=(1 / pl.col("n_pass")).replace(
                    [float("inf"), float("-inf")], 0
                )
            )
        )

    def simulate_jobsearch(
        n_applications: int = n_applications.value,
        config: JobInterviewConfig = JobInterviewConfig(),
    ) -> pl.DataFrame:
        process = pl.concat(
            [
                sample_interview(config, interview_id=i)
                for i in range(n_applications)
            ]
        )
        result = summarize_application(process)
        return result

    def get_poffer(df: pl.DataFrame) -> float:
        probs = df.get_column("p_pass").to_numpy()
        return 1 - np.cumprod(1 - probs)[-1]

    def get_poffer_distribution(
        n_applications: int = n_applications.value,
        config: JobInterviewConfig = JobInterviewConfig(),
        n_runs: int = n_runs.value,
    ) -> pl.DataFrame:
        return pl.DataFrame(
            {
                "p_offer": np.array(
                    [
                        get_poffer(
                            simulate_jobsearch(
                                n_applications=n_applications, config=config
                            )
                        )
                        for _ in range(n_runs)
                    ]
                ).tolist()
            }
        )

    def get_poffer_by_n(df: pl.DataFrame) -> np.ndarray:
        probs = df.get_column("p_pass").to_numpy()
        return 1 - np.cumprod(1 - probs)

    def get_poffer_by_n_distribution(
        n_applications: int = n_applications.value,
        config: JobInterviewConfig = JobInterviewConfig(),
        n_runs: int = n_runs.value,
    ) -> pl.DataFrame:
        return pl.DataFrame(
            {"application_number": np.arange(n_applications).tolist()}
            | {
                f"p_offer_{i}": get_poffer_by_n(
                    simulate_jobsearch(
                        n_applications=n_applications, config=config
                    )
                ).tolist()
                for i in range(n_runs)
            }
        )

    return (
        get_poffer_by_n_distribution,
        get_poffer_distribution,
        simulate_jobsearch,
    )


@app.cell(hide_code=True)
def _(alt, cs, pl):
    def _per_col(value, col):
        """Return the per-column value if `value` is a dict, else the value itself."""
        if isinstance(value, dict):
            return value.get(col)
        return value

    def stacked_histograms(
        df: pl.DataFrame,
        columns: list[str] | None = None,
        bin_step: float | dict | None = None,
        maxbins: int | dict = 50,
        x_range: tuple | dict | None = None,
        y_range: tuple | dict | None = None,
        scheme: str = "tableau10",
        share_x: bool = False,
        width: int = 320,
        height: int = 120,
        opacity: float = 0.85,
    ) -> alt.VConcatChart:
        # Default: every numeric column
        if columns is None:
            columns = [
                c for c, dtype in df.schema.items() if dtype.is_numeric()
            ]

        # One color per panel, drawn from the chosen scheme
        color = alt.Color(
            "variable:N",
            scale=alt.Scale(scheme=scheme, domain=columns),
            legend=None,
        )

        charts = []
        for col in columns:
            step = _per_col(bin_step, col)
            nbins = _per_col(maxbins, col)
            xr = _per_col(x_range, col)
            yr = _per_col(y_range, col)

            # Bin spec: a fixed step wins over maxbins; extent pins bins to the x range
            bin_kwargs = {"step": step} if step else {"maxbins": nbins}
            if xr is not None:
                bin_kwargs["extent"] = list(xr)

            # Long-format slice for this panel; drop values outside the x range
            sub = df.select(
                pl.col(col).cast(pl.Float64).alias("value"),
                pl.lit(col).alias("variable"),
            ).drop_nulls()
            if xr is not None:
                sub = sub.filter(pl.col("value").is_between(xr[0], xr[1]))

            x = alt.X(
                "value:Q",
                bin=alt.Bin(**bin_kwargs),
                title=col,
                scale=alt.Scale(domain=list(xr))
                if xr is not None
                else alt.Undefined,
            )
            y = alt.Y(
                "count():Q",
                title="count",
                scale=alt.Scale(domain=list(yr))
                if yr is not None
                else alt.Undefined,
            )

            chart = (
                alt.Chart(sub)
                .mark_bar(opacity=opacity, clip=True)
                .encode(
                    x=x,
                    y=y,
                    color=color,
                    tooltip=[
                        alt.Tooltip(
                            "value:Q", bin=alt.Bin(**bin_kwargs), title="bin"
                        ),
                        alt.Tooltip("count():Q", title="count"),
                    ],
                )
                .properties(width=width, height=height, title=col)
            )
            charts.append(chart)

        return alt.vconcat(*charts, spacing=15).resolve_scale(
            x="shared" if share_x else "independent",
            y="independent",
            color="shared",
        )

    def into_cumulative_probability(df: pl.DataFrame) -> pl.DataFrame:
        return (
            df.unpivot(index="application_number", on=cs.matches("p_offer*"))
            .drop("variable")
            .rename({"value": "p_offer"})
        )

    def plot_cumulative_probability_with_application(df: pl.DataFrame):
        return (
            alt.Chart(into_cumulative_probability(df))
            .mark_line()
            .encode(
                alt.X("application_number"),
                alt.Y("p_offer"),
                alt.Tooltip("application_number", "p_offer"),
            )
        )

    def plot_cumulative_probability_with_application_in_days(
        df: pl.DataFrame, applications_per_week: int
    ):
        return (
            alt.Chart(
                into_cumulative_probability(df).with_columns(
                    day_number=pl.col("application_number")
                    / applications_per_week
                    * 7
                )
            )
            .mark_line()
            .encode(
                alt.X("day_number"),
                alt.Y("p_offer"),
                alt.Tooltip("application_number", "p_offer"),
            )
        )

    return (
        plot_cumulative_probability_with_application,
        plot_cumulative_probability_with_application_in_days,
        stacked_histograms,
    )


@app.cell
def _(get_poffer_distribution, mo, n_applications, np, simulate_jobsearch):
    probs = simulate_jobsearch().get_column("p_pass").to_numpy()
    p_offer = 1 - np.cumprod(1 - probs)[-1]
    p_offer_arr = get_poffer_distribution().get_column("p_offer").to_numpy()
    pmean = p_offer_arr.mean()
    pstd = p_offer_arr.std()

    mo.md(f"""\
    Now we have `m` applications `A1...Am`, and for each of them we have respective probability to get an offer for the application.

    For this single process that we've simulated, we get probability of getting an offer of `1-(1-p1)(1-p2)...(1-pn)`:

    ```
    p = {p_offer:0.2f}
    ```

    However, now we'd like to get a distribution of these probabilities, to estimate our confidence in getting an offer or smth.

    So we're running this application search {n_applications.value} times, and the distribution we get, is shown below. Roughly, we get:

    ```
    p = {pmean:0.2f} +- {pstd:0.2f}
    ```

    _(note: simulations with default values are big enough so that we don't see any variability in practice)_


    Below you can see a cumulative distribution of pffer probability vs application number that you submit.
    """)
    return


@app.cell(hide_code=True)
def _(
    alt,
    applications_per_week,
    get_poffer_by_n_distribution,
    plot_cumulative_probability_with_application,
    plot_cumulative_probability_with_application_in_days,
):
    alt.hconcat(
        plot_cumulative_probability_with_application(
            get_poffer_by_n_distribution()
        ),
        plot_cumulative_probability_with_application_in_days(
            get_poffer_by_n_distribution(),
            applications_per_week=applications_per_week.value,
        ),
    ).interactive()
    return


@app.cell
def _(simulate_jobsearch, stacked_histograms):
    stacked_histograms(
        simulate_jobsearch(),
        columns=[
            "n_hr_pass",
            "n_team_pass",
            "n_interview_pass",
            "n_pass",
            "p_pass",
        ],
    )
    return


if __name__ == "__main__":
    app.run()
