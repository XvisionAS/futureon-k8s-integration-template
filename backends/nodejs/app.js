const logger       = require('morgan')
const bodyParser   = require('body-parser')
const cors         = require('cors')
const express      = require('express')
const compression  = require('compression')

const app = express()


const shouldCompress = (req, res) => {
  if (req.headers['x-no-compression']) {
    // don't compress responses with this request header
    return false
  }
  // fallback to standard filter function
  return compression.filter(req, res)
}

app.use(compression({
  filter: shouldCompress
}))

app.use('/healthz', function(req, res, next) {
  res.status(200).send('ok')
})

app.use('/ready', function(req, res, next) {
  res.json({ ready:true }).end()
})


app.disable('x-powered-by')

app.use(logger('dev'))
app.use(bodyParser.json({ limit: '150mb' }))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(cors({ origin: true, credentials: true }))


app.use('/*', function(req, res, next) {
  return res.status(200).send(`
    <html>
      <body>Integration Backend</body>
    </html>
  `).end()
})

module.exports = app
