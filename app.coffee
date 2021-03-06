# Module dependencies.
express = require('express')
routes = require('./routes')
http = require('http')
path = require('path')
calendar = require('./calendar.coffee')
util = require('util')

process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0'
cal = new calendar.Calendar(process.env.DOBBY_ICAL_URL, process.env.DOBBY_ICAL_USER, process.env.DOBBY_ICAL_PASS)

app = express()

# all environments
app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))


# development only
if 'development' == app.get('env')
  app.use express.errorHandler()

app.get '/' , (req, res) ->
	res.render 'index', {
		title: 'Calendar',
		calendar: cal
	}

app.get '/raw' , (req, res) ->
	res.render 'raw', {
		title: 'Calendar',
		raw: cal.raw
	}

http.createServer(app).listen(app.get('port'))
