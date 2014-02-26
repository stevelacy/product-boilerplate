request = require 'supertest'
app = require '../../start'
config = require '../../config'
setup = require '../setup'

should = require 'should'
require 'mocha'

describe 'User GET', ->
  beforeEach setup.db.wipe
  beforeEach setup.user.create
  beforeEach setup.passport.hook
  afterEach setup.passport.unhook

  it 'should respond with 200 and information when logged in', (done) ->
    request(app)
      .get("#{config.apiPrefix}/users/#{setup.user.id}")
      .set('Accept', 'application/json')
      .query(setup.user.createQuery(setup.user.id))
      .expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal setup.user.id
        should.exist res.body.token, 'should show user token'
        done()

  it 'should respond with 200 and information when not logged in', (done) ->
    request(app)
      .get("#{config.apiPrefix}/users/#{setup.user.id}")
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal setup.user.id
        should.not.exist res.body.token, 'should not show user token'
        done()

  it 'should respond with 200 and information when logged in with username query', (done) ->
    request(app)
      .get("#{config.apiPrefix}/users/#{setup.user.username}")
      .set('Accept', 'application/json')
      .query(setup.user.createQuery(setup.user.id))
      .expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal setup.user.id
        should.exist res.body.token, 'should show user token'
        done()

  it 'should respond with 200 and information when not logged in with username query', (done) ->
    request(app)
      .get("#{config.apiPrefix}/users/#{setup.user.username}")
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal setup.user.id
        should.not.exist res.body.token, 'should not show user token'
        done()