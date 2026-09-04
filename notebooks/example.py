# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "marimo>=0.24.0",
# ]
# ///
import marimo

__generated_with = "0.24.0"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import numpy as np
    import matplotlib.pyplot as plt
    return mo, np, plt


@app.cell
def _(mo):
    mo.md(
        r"""
        # A tiny interactive example

        Drag the slider to change the frequency of the sine wave below —
        this notebook runs entirely in your browser via WebAssembly
        (Pyodide), no server required.
        """
    )
    return


@app.cell
def _(mo):
    frequency = mo.ui.slider(1, 10, value=3, step=1, label="Frequency")
    frequency
    return (frequency,)


@app.cell
def _(frequency, np, plt):
    x = np.linspace(0, 2 * np.pi, 400)
    y = np.sin(frequency.value * x)

    fig, ax = plt.subplots()
    ax.plot(x, y)
    ax.set_title(f"sin({frequency.value} · x)")
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    fig
    return


if __name__ == "__main__":
    app.run()
