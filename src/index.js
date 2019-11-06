#!/usr/bin/env node

const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const ytdl = require('youtube-dl')

app.use(bodyParser.json())

const port = process.env.PORT || 8080

app.get('/info', (req, res) => {
  const { url = '' } = req.query

  ytdl.getInfo(url, (err, info) => {
    if (err) {
      res.status(500).json({ err })
      return
    }

    res.json({
      id: info.id,
      title: info.title,
      url: info.url,
      thumbnail: info.thumbnail,
      description: info.description,
      format: info.format
    })
  })
})

app.get('/health', (req, res) => res.send('OK'))

app.listen(port, () =>
  console.log(`Listening on localhost: http://localhost:${port}`)
)
