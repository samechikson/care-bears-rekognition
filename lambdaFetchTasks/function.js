const { Client } = require('pg')
const connectionString = 'postgres://test:test@localhost:5432/iot'

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

  let res;
  try {
    res = await client.query(`
      SELECT id, name, barcode, time_targeted_first, time_targeted_last, room_id
	        FROM tasks WHERE room_id = $1`, [event.roomId])
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

  callback(null, res.rows);
}
