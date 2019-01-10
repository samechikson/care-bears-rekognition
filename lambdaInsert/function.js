const { Client } = require('pg')
const connectionString = 'postgres://root:careb3ars@iotdatabase.c9a0to4gswgm.us-east-1.rds.amazonaws.com:5432/iot'

exports.handler = async function (event, context, callback) {
  const client = new Client({
    connectionString: connectionString
  })

  try {
    await client.connect()
  } catch (e) {
    console.error(`Couldn't connect`, e);
    callback(e)
  }

  try {
    const res = await client.query(`INSERT INTO ${event.tableName}(device_id, time_recieved) VALUES ($1, $2)`, [event.id, new Date()])
    console.log(res.rows) // Hello world!
  } catch (e) {
    console.error(`Couldn't query`, e)
    callback(e)
  }
  try {
    await client.end()
  } catch (e) {
    console.error(`Couldn't close connection`, e);
    callback(e)
  }

  callback(null, `Successully enter 1 record into table ${event.tableName} in database 'iot'`);
}