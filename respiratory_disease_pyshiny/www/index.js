$(() => {
  Shiny.addCustomMessageHandler("toggleActiveTab", (payload) => {
    $(".page-main").removeClass("main-visible");
    $(`#${payload.activeTab}-container`).addClass("main-visible");
  });
});
