<!--
Copyright 2012 The Infinit.e Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Infinit.e API Entity Suggest Example</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
	
	<link rel="shortcut icon" href="image/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="lib/codemirror.css" />
	
    <!-- Le styles -->
    <link href="lib/bootstrap/css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 800px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>
    <link href="lib/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    
    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    
    <script type="text/javascript" src="lib/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="lib/bootstrap/js/jquery-latest.js"></script>
   	<script type="text/javascript" src="lib/codemirror.js"></script>
    
	<style type="text/css">
      .CodeMirror { border: 1px solid #eee; }
      td { padding-right: 20px; }
    </style>

</head>
<body>

<div class="container">

	<div class="form-signin">
      
    	<h3 class="form-signin-heading">Infinit.e API Example - Using Entity Suggest</h2>
    	
    	<div class="alert alert-success">
  			<span class="label label-success">Instructions</span> The following form is an example application built using 
  			Bootstrap (<a href="http://twitter.github.com/bootstrap/">http://twitter.github.com/bootstrap/</a>), 
  			JQuery (<a href="http://jquery.com/">http://jquery.com/</a>), and Codemirror 
  			(<a href="http://codemirror.net/">http://codemirror.net/</a>) to access the Infinit.e API. 
  			Run the example using the instructions below:
  			<br /><br />
  			<ol>
  				<li>Enter your Infinit.e API key and click on the <strong>Get Communities</strong> button. 
  					(<strong>Note:</strong> the JSON returned by the server will be displayed in the output box at the bottom of 
  					the page for reference purposes.)</li>
  				<li>Select one or more of the communities in the Communities option list.</li>
  				<li>Enter a fragment of text to search on and click on the <strong>Get Entity Suggestions</strong> button.</li>
  			</ol>
		</div>
		
		<table class="table">
			<tr>
				<td><span class="label label-success">API Key:</span></td>
				<td><input type="text" id="apiKey" placeholder="API Key"></td>
				<td><button class="btn" id="getCommunities">Get Communities</button></td>
			</tr>
			<tr>
				<td><span class="label label-success">Communities:</span></td>
				<td colspan="2">
					<select id="communitiesList" multiple="multiple"></select>
				</td>
			</tr>
			<tr>
				<td><span class="label label-success">Fragment:</span></td>
				<td><input type="text" id="fragment" placeholder="Search fragment"></td>
				<td><button class="btn" id="getEntities">Get Entity Suggestions</button></td>
			</tr>
			<tr>
				<td colspan="3">
					<textarea id="testJson" name="testJson"></textarea>
				</td>
			</tr>
		</table>
		

</div> <!-- /container -->

</body>
</html>

<!---------- CodeMirror JavaScripts ---------->
<script>
	var testEditor = CodeMirror.fromTextArea(document.getElementById("testJson"), {
		theme: 'default',
	  	lineNumbers: true,
	    matchBrackets: true
	});
</script>

<!---------- JQuery Code ---------->
<script>

	var apiRoot = "http://api.ikanow.com/";
	$(document).ready(function () {
		// Button click handlers
		$("#getCommunities").click(function() { getCommunities(); });
		$("#getEntities").click(function() { getEntities(); });
	});

	function getEntities()
	{
		var communityList = $('select#communitiesList').val();
		
		var apiKey = $('#apiKey').val();
		if (apiKey.length > 0) {
			var apiCall = apiRoot + "api/knowledge/feature/entitySuggest/" +
				$("#fragment").val() + "/" + communityList + "?infinite_api_key=" + apiKey + "&geo=true&linkdata=true";
			
			var response = $.ajax({
				type: 'GET',
				url: 'get.jsp?addr=' + apiCall,
				async: false,
				contentType: "application/json",
				dataType: 'text'
			});
			response.done(function(msg) {
				jsonResponse = msg;
			});
	
			if (jsonResponse.length > 0) {
				var jsonObj = jQuery.parseJSON(jsonResponse);
				testEditor.setValue(JSON.stringify(jsonObj,null,'\t'));
			}
		}
		else {
			
		}
	}
	
	
	
	
	function getCommunities()
	{
		var apiKey = $('#apiKey').val();
		if (apiKey.length > 0) {
			// API Call - Person Get to return person object for user with API key passed in
			var apiCall = apiRoot + "api/social/person/get?infinite_api_key=" + apiKey;
			var response = $.ajax({
				type: 'GET',
				url: 'get.jsp?addr=' + apiCall,
				async: false,
				contentType: "application/json",
				dataType: 'text'
			});
			response.done(function(msg) {
				jsonResponse = msg;
			});
	
			if (jsonResponse.length > 0) {
				var jsonObj = jQuery.parseJSON(jsonResponse);
				testEditor.setValue(JSON.stringify(jsonObj,null,'\t'));
				
				if (jsonObj.response.success == true) {
					var communities = jsonObj.data.communities;
					var communityContainer = $('#communitiesList');
					communityContainer.empty();
					
					for (var i=0; i < communities.length; i++) {
						var community = communities[i];
						$('#communitiesList').append($('<option>', { value: community._id, text : community.name }));
					}
				}
				else {
				}
			}
		}
		else {
			//$("#login-error").show();
		}
	}
	

	
</script>