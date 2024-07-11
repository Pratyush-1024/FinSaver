const express = require ("express");
const mongoose = require ("mongoose");
const balanceRouter = require('./routes/monthlyBalance');
const authRouter = require ("./routes/auth");
const notificationRouter = require("./routes/notifications");
const userBankDetailsRouter = require('./routes/userBankDetails');
const userMoreDetailsRouter = require('./routes/userMoreDetails');
const transactionsRouter = require('./routes/transaction');
const docsRouter = require('./routes/docs');


const PORT = 3000;

const app = express();

const DB = "mongodb://pratyushyadav2003:bcp9NzXOuCMlmLxj@ac-suyhoeu-shard-00-00.r59dnbs.mongodb.net:27017,ac-suyhoeu-shard-00-01.r59dnbs.mongodb.net:27017,ac-suyhoeu-shard-00-02.r59dnbs.mongodb.net:27017/?ssl=true&replicaSet=atlas-jbw6gm-shard-0&authSource=admin&retryWrites=true&w=majority&appName=Cluster0"; 

app.use(express.json());
app.use(authRouter);
app.use(notificationRouter);
app.use(userBankDetailsRouter);
app.use(userMoreDetailsRouter);
app.use(transactionsRouter);
app.use(balanceRouter);
app.use('/uploads', express.static('uploads'));
app.use(docsRouter);

mongoose.connect(DB).then(()=>{
    console.log('connection success');
}).catch((e)=>{
    console.log(e);
});

app.listen(PORT , "0.0.0.0", (req,res)=>{
    console.log(`connected at port ${PORT}`);
})