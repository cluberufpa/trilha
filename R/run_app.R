#' Abrir a aplicação Shiny da Trilha
#'
#' @param launch.browser `TRUE` para abrir a Trilha automaticamente no
#'   navegador padrão; `FALSE` para apenas iniciar o servidor e mostrar o
#'   endereço local no console. Também aceita uma função compatível com
#'   [shiny::runApp()].
#' @param ... Outros argumentos repassados para [shiny::runApp()], como `port`
#'   e `host`.
#' @examples
#' \dontrun{
#' # Abrir no navegador padrão
#' run_app(launch.browser = TRUE)
#'
#' # Iniciar sem abrir o navegador automaticamente
#' run_app(launch.browser = FALSE)
#' }
#' @export
run_app <- function(
    launch.browser = TRUE,
    ...) {
  app_dir <- system.file("app", package = "trilha")
  if (app_dir == "") {
    stop(
      "N\u00e3o foi poss\u00edvel encontrar o diret\u00f3rio do aplicativo. ",
      "Tente reinstalar o pacote `trilha`.",
      call. = FALSE
    )
  }
  shiny::runApp(app_dir, launch.browser = launch.browser, ...)
}
