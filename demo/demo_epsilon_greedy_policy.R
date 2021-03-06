library(contextual)

policy             <- EpsilonGreedyPolicy$new(epsilon = 0.1)

bandit             <- BasicBernoulliBandit$new(weights = c(0.6, 0.1, 0.1))

agent              <- Agent$new(policy,bandit)

simulator          <- Simulator$new(agents      = agent,
                                    horizon     = 100,
                                    simulations = 1000)
simulator$run()

plot(simulator$history, type = "cumulative", regret = TRUE, disp = "ci",
                        traces = TRUE, traces_max = 100, traces_alpha = 0.1)

summary(simulator$history)
