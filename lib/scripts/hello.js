// Description
//   A Hubot script that DESCRIPTION
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot XXX [<args>] - DESCRIPTION
//
// Author:
//   bouzuya <m@bouzuya.net>
//
module.exports = function(robot) {
  return robot.respond(/(?:.*)\ssleepy/i, function(res) {
    var hours, now;
    now = new Date();
    hours = now.getHours();
    if (hours < 6) {
      return res.send('Sleep again');
    } else if (hours < 10) {
      return res.send('Wake up');
    } else if (hours < 21) {
      return res.send('Not yet');
    } else {
      return res.send('Go to bed');
    }
  });
};
