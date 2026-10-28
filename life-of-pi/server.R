


library(ggplot2)
library(gganimate)
library(ggforce)
library(glue)
library(waiter)

server = function(input, output, session){

  waiter_hide()

  observeEvent(input$go_to_work, {
    updateNavbarPage(session = session, "navbar", "Work")
  })

  ## initialize loading screen for anim1
  w1 = Waiter$new(
    id = "anim1",
    html = tagList(
      div(
        spin_loaders(42, color = "#aaa"),
        div("Loading...",style = "color:#aaa;")
    )),
    color = "#272b30"
  )

  ## intialize loading screen for anim2
  w2 = Waiter$new(
    id = "anim2",
    html = tagList(
      div(
        spin_loaders(42, color = "#aaa"),
        div("Loading...", align = "left", style = "color:#aaa;")
      )),
    color = "#272b30"
  )

  observeEvent(input$run, {
    n = suppressWarnings(as.integer(input$n))
    req(n %in% slider_vals)  # input$n is client-controlled; reject anything off the slider
    disable(id = "run")

    output$anim1 = renderImage({

      w1$show()  # show the waiter screen
      on.exit(w1$hide())  # hide it even if rendering fails
      outfile <- tempfile(fileext='.gif')

      if(n %in% pre_rendered) {
        file.copy(file.path('./anims2', glue("anim1_{n}.gif")), outfile)  # copy pre-rendered image; outfile is deleted after serving
      }

      else{
        anim1 = make_anim1(the_data(n))  # make the animation
        save_animation(anim1, outfile)
      }

      list(src = outfile,
           contentType = 'image/gif'
      )

    }, deleteFile = TRUE)

    ##############################################
    output$anim2 = renderImage({
      w2$show()
      on.exit({
        w2$hide()
        delay(10000, enable("run"))  # enable the action button when animation is done, even on error
      })
      outfile <- tempfile(fileext='.gif')

      if(n %in% pre_rendered) {
        file.copy(file.path('./anims2', glue("anim2_{n}.gif")), outfile)
      }

      else {
        anim2 = make_anim2(the_data(n))
        save_animation(anim2, outfile)
      }

      list(src = outfile,
           contentType = 'image/gif'
      )
    }, deleteFile = TRUE)

  })
}
