{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @sender = new User 'bouzuya', room: 'hitoridokusho'
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot I\'m sleepy"', ->
      beforeEach ->
        message = '@hubot I\'m sleepy'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @callback.callCount is 1
        match = @callback.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is '@hubot I\'m sleepy'

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot I\'m sleepy"', ->
      beforeEach ->
        @send = @sinon.spy()
        @params =
          match: ['@hubot I\'m sleepy']
          send: @send

      describe '05:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 5).getTime())
          @response = 'Sleep again'
          @hello @params

        it 'send "Sleep again"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response

      describe '06:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 6).getTime())
          @response = 'Wake up'
          @hello @params

        it 'send "Wake up"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response

      describe '09:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 9).getTime())
          @response = 'Wake up'
          @hello @params

        it 'send "Wake up"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response

      describe '10:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 10).getTime())
          @response = 'Not yet'
          @hello @params

        it 'send "Not yet"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response

      describe '20:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 20).getTime())
          @response = 'Not yet'
          @hello @params

        it 'send "Not yet"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response

      describe '21:00', ->
        beforeEach ->
          @sinon.useFakeTimers(new Date(2014, 1, 1, 21).getTime())
          @response = 'Go to bed'
          @hello @params

        it 'send "Go to bed"', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is @response
