library(contextual)
library(here)
library(data.table)

setwd(here("demo","replication_kruijswijk_2018"))

source("./policy_pooled_egreedy.R")
source("./bandit_bootstrapped_replay.R")

horizon     <- 570000
simulations <- 10

csv_url     <- "http://d1ie9wlkzugsxr.cloudfront.net/data_persuasion_api/persuasion_api_simple.csv"
data        <- fread(csv_url, nrows = horizon)

data$user   <- as.numeric(factor(data$user, levels = unique(data$user)))
data$choice <- data$choice
users       <- data[, .N, keyby = user]

max_repeat  <- max(users$N)
n_users     <- length(users$user)

print(max_repeat)
print(n_users)

table(data$choice)
#1      2      3      4
#142628 142860 142439 142073

##################### Bandit ###########################

bandit      <- DependentObservationsBootstrappedBandit$new(data, 4)

##################### Policies #########################

agents      <- list(Agent$new(UnpooledEgreedyPolicy$new(epsilon = 0.1, n_subjects = n_users), bandit),
                    Agent$new(PooledEgreedyPolicy$new(epsilon = 0.1), bandit),
                    Agent$new(PartiallyPooledEgreedyPolicy$new(epsilon = 0.1, n_subjects = n_users), bandit))

history     <- Simulator$new(agents = agents, horizon = horizon,
                             simulations = simulations, save_interval = 50)$run()

plot(history, type = "cumulative", regret = FALSE, rate = TRUE, ylim = c(0.01,0.03))
