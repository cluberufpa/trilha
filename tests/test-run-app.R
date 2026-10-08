stopifnot(
  "launch.browser" %in% names(formals(trilha::run_app)),
  "..." %in% names(formals(trilha::run_app))
)

cat("OK: run_app expõe launch.browser e mantém argumentos adicionais\n")
