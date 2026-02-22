const mysql = require('mysql2');
const fs = require('fs');
const csv = require('csv-parser');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '12@@ATc.',
  database: 'marketing_data'
});

const results = [];

fs.createReadStream('marketing_data_clean.csv')
  .pipe(csv())
  .on('data', (data) => results.push(data))
  .on('end', () => {
    results.forEach(row => {
      const keys = Object.keys(row).map(k => `\`${k.trim()}\``).join(', ');
      const values = Object.values(row).map(v => v.trim());
      const placeholders = values.map(() => '?').join(', ');
      connection.query(`INSERT INTO marketing (${keys}) VALUES (${placeholders})`, values, (err) => {
        if (err) console.error(err);
      });
    });
    console.log(`Inserted ${results.length} rows`);
  });

