model <- '
# outcome model 
outcomeVar ~ c*xVar + b1*medVar1 + b2*medVar2

# mediator models
medVar1 ~ a1*xVar 
medVar2 ~ a2*xVar

# indirect effects (IDE)
medVar1IDE  := a1*b1
medVar2IDE  := a2*b2
sumIDE := (a1*b1) + (a2*b2)

# total effect
total := c + (a1*b1) + (a2*b2)
medVar1 ~~ medVar2 # model correlation between mediators
'
