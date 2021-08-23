/* AWS Lambda function that is periodically invoked to to start an AWS CodePipeline pipeline. */

exports.handler = function(event, context, callback) {
	"use strict";

	const pipelineName = "pipeline-deploy-autoscar-frontend";

	const AWS = require('aws-sdk');

	let codepipeline = new AWS.CodePipeline();

	let params = {
			name: pipelineName
	};

	codepipeline.startPipelineExecution(params, function(err, data) {
	  	if (err) {
	   		console.log(err, err.stack);
	   	}
	   	else { 
			console.log(data);
		}           
	 });

	callback(null, 'Autoscar Frontend project build started.');
}