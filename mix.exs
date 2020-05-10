defmodule Project.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Boatify",
      source_url: "https://git.fic.udc.es/diego.villanueva/boatify/commits/master",
      docs: [
       main: "Boatify", # The main page in the docs
       extras: ["README.md"]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:csv, "~> 2.3"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end
end
