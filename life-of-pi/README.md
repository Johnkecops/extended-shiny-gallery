# Life of Pi: A Monte Carlo Simulation

---

- Developed by: [Zauad Shahreer Abeer](https://github.com/shahreyar-abeer)
- App on gallery: https://gallery.shinyapps.io/life-of-pi
- Original code: https://github.com/shahreyar-abeer/life_of_pi

---

This app is designed to run a Monte Carlo Simulation to estimate the value of π.
I'm sorry to disappoint some of you who might have though it had something to do with the movie.
But I can share a bit of history though.

Pi wasn’t always known as pi. Before the 1700s, people referred to the number we know as pi as
'the quantity which when the diameter is multiplied by it, yields the circumference'.
Not surprisingly, people got tired of saying so much whenever they wanted to talk about Pi.
The Welsh mathematician William Jones, a friend of Sir Isaac Newton, began using the symbol for π in 1706.


## The Algorithm
At first, we inscribe a circle with unit radius (r=1) in a square (length=2r),
note down the area of the circle and the square.
Then we let some points fall freely on the canvass.
The points are independent and may fall at any place within the square.
We then take a note of the poportion (p) of points that have fallen inside the circle to the total number of points.
This proportion gives 1/4 th of π. We then multiply the result with 4 to get an estimate of π.

## Running the app

Requires R (tested with 4.5) and these CRAN packages:

```r
install.packages(c(
  "shiny", "bslib", "waiter", "bsplus", "shinyjs", "shinyWidgets",
  "ggplot2", "gganimate", "ggforce", "glue", "gifski", "hrbrthemes"
))
```

Tested versions: shiny 1.14.0, bslib 0.10.0, waiter 0.2.5.1, bsplus 0.1.5, shinyjs 2.1.1,
shinyWidgets 0.9.1, gganimate 1.0.11, ggforce 0.5.0, gifski 1.32.0.2, hrbrthemes 0.9.3.

Start it from the folder that holds `global.R`, `ui.R` and `server.R`:

```r
shiny::runApp("path/to/life-of-pi")
```

or from a terminal:

```bash
Rscript -e 'shiny::runApp("life-of-pi", port = 8765, launch.browser = TRUE)'
```

In RStudio you can also open `ui.R` or `server.R` and click **Run App**.

Using it:

1. On the **Home** tab, click **Enough chit-chat, let's get to work!** to open the **Work** tab.
2. Pick the number of points on the slider and click **Let's run!**.
3. The left animation shows points falling inside or outside the circle; the right one shows the running estimate of π against the true value (dashed line).

100, 1000, 10000 and 10002 load from pre-rendered GIFs in `anims2/` and appear within a second or two.
Any other value is rendered live with gganimate, which takes noticeably longer. The **Let's run!** button
stays disabled while the animation renders and plays (about 10 seconds after it appears).

Check the simulation function:

```bash
Rscript tests/test_the_data.R   # prints "ok"
```

---

AI Assistance Disclaimer: This codebase was developed with the assistance of Claude Code. While the AI provided code generation, debugging, and structural support, the human developer maintains full responsibility for reviewing, testing, and maintaining all content and functionality
