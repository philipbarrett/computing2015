#####################################################################################
# session.R - Sample session code for optimal choice model                          #
#                                                                                   #
# Philip Barrett, Chicago                                                           #
# Created: 28jan2015                                                                #
# Based heavily on code for TAing Ken Judd's class in Fall 2013                     #
#####################################################################################

## 1. Source the function definitions ##
setwd('/home/philip/code/2015/teaching/computing2015/optChoice/')
    # Current working directory. ** Needs changing on local system. **
st.fldr <- 'R' # 'Rbad/'
for (nm in list.files(st.fldr, pattern = '\\.[R]$'))
  source(file.path(st.fldr, nm) )

## 2. Mess around, plot some pictures ##
opt.choice( c(1, 1, 1, 1, 1), 2, c( .2, .2, .2, .2, .2 ), 1 )
opt.choice( c(.5, 1, 1, 1, 1), 2, c( .2, .2, .2, .2, 6 ), 4 )
opt.choice( c(.5, 10, .1, 3, 2), .5, c( .2, .1, 5, .2, 1 ), 30 )
    # Does not work.  Does work.
opt.elasticity.fd( c(1,1,1,1,1), 1, rep(.2, 5), 1 )
opt.elasticity.fd( c(1,1,1,1,1), 2, rep(.2, 5), 1 )
opt.elasticity.fd( c(.5,1,1,1,1), 4, rep(.2, 5), 1 )
    # Check the elasticities
plot.demand.rho( seq( .5, 2, by = .5 ), c( .2, .2, .2, .2, .2 ), 1, 
                 c(1, 1, 1, 1, 1), c(0.1, 1.5) )
plot.demand.rho( seq( .5, 1.2, by = .1 ), c( .2, .2, .2, .2, .2 ), 1, 
                 c(1, 1, 1, 1, 1), c(0.1, 1.5 ), log.flag=TRUE )
