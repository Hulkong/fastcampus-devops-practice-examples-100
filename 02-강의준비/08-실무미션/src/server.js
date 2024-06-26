const app = require('./index');
const PORT = process.env.PORT || 3000;
const version = process.env.VERSION || 'v1';

app.listen(PORT, () => {
  console.log(`This verions is ${version}`);
});