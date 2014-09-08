# Description
#   A Hubot script that DESCRIPTION
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot XXX [<args>] - DESCRIPTION
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /(?:.*)\ssleepy/i, (res) ->
    now = new Date()
    hours = now.getHours()
    if hours < 6
      res.send 'Sleep again'
    else if hours < 10
      res.send 'Wake up'
    else if hours < 21
      res.send 'Not yet'
    else
      res.send 'Go to bed'
