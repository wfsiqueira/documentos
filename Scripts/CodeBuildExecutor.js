exports.handler = (event) => {
    const AWS = require("aws-sdk");
    const codebuild = new AWS.CodeBuild();
    const build = {
       projectName: "tic-ecommerce-build"
    };
    codebuild.startBuild(build,function(err, data){
        if (err) {
            console.log("Inside Error!");
            console.log(err, err.stack);
        }
        else {
            console.log("Outside Error!");
            console.log(data);
        }
    });
};