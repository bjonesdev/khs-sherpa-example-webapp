<script type="text/javascript"
	src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

<script type="text/javascript">
	function RealTypeOf(v) {
		if (typeof (v) == "object") {
			if (v === null)
				return "null";
			if (v.constructor == (new Array).constructor)
				return "array";
			if (v.constructor == (new Date).constructor)
				return "date";
			if (v.constructor == (new RegExp).constructor)
				return "regex";
			return "object";
		}
		return typeof (v);
	}

	function FormatJSON(oData, sIndent) {
		if (arguments.length < 2) {
			var sIndent = "";
		}
		var sIndentStyle = "    ";
		var sDataType = RealTypeOf(oData);
		if (sDataType == "array") {
			if (oData.length == 0) {
				return "[]";
			}
			var sHTML = "[";
		} else {
			var iCount = 0;
			$.each(oData, function() {
				iCount++;
				return;
			});
			if (iCount == 0) {
				return "{}";
			}
			var sHTML = "{";
		}
		var iCount = 0;
		$.each(oData,
				function(sKey, vValue) {
					if (iCount > 0) {
						sHTML += ",";
					}
					if (sDataType == "array") {
						sHTML += ("\n" + sIndent + sIndentStyle);
					} else {
						sHTML += ("\n" + sIndent + sIndentStyle + "\"" + sKey
								+ "\"" + ": ");
					}

					switch (RealTypeOf(vValue)) {
					case "array":
					case "object":
						sHTML += FormatJSON(vValue, (sIndent + sIndentStyle));
						break;
					case "boolean":
					case "number":
						sHTML += vValue.toString();
						break;
					case "null":
						sHTML += "null";
						break;
					case "string":
						sHTML += ("\"" + vValue + "\"");
						break;
					default:
						sHTML += ("TYPEOF: " + typeof (vValue));
					}
					iCount++;
				});
		if (sDataType == "array") {
			sHTML += ("\n" + sIndent + "]");
		} else {
			sHTML += ("\n" + sIndent + "}");
		}
		return sHTML;
	}
</script>

<script type="text/javascript">
	function processOutput(data, outputid) {
		y = FormatJSON(data, "");
		$(outputid).val(y);
	}

	function callServerEndpoint(url, outputid) {
		$.getJSON(url, function(data) {
			processOutput(data, outputid);
		});
	}

	$(document).ready(
			function() {

				$("#quote").click(
						function() {
							service = $("#service").val();
							method = $("#method").val();
							ticker = $("#ticker").val();
							url = "sherpa?endpoint=" + service + "&action="
									+ method + "&ticker=" + ticker;
							callServerEndpoint(url, "#output");
							return false;
						});

				$("#add").click(
						function() {
							service = $("#testendpoint").val();
							method = $("#addmethod").val();
							x = $("#x").val();
							y = $("#y").val();
							url = "sherpa?endpoint=" + service + "&action="
									+ method + "&x_value=" + x + "&y_value=" + y;
							callServerEndpoint(url, "#output");
							return false;
						});
	
				
				$("#authenticate").click(
						function() {
							method = $("#action").val();
							userid = $("#userid").val();
							password = $("#password").val();
							url = "sherpa?action=" + method + "&userid="
									+ userid + "&password=" + password;
							callServerEndpoint(url, "#output");
							return false;
						});

				$("#authenticated-endpoint").click(
						function() {
							endpoint = $("#endpoint-a").val();
							method = $("#action-a").val();
							userid = $("#userid-a").val();
							token = $("#token-a").val();
							url = "sherpa?endpoint=" + endpoint + "&action="
									+ method + "&userid=" + userid + "&token="
									+ token;
							callServerEndpoint(url, "#output");
							return false;
						});

			});
</script>

<H1>khsSherpa Example JSON Endpoints</H1>

<div>

   <!--  JSON Results  -->
	<div style="float: right">
		JSON Results <br />
		<textarea id="output" cols="80" rows="8"></textarea>
	</div>

   <!-- ENDPOINT Examples -->

	<div style="float: left">
		<table border="0">
		
			<!-- Stock QUOTE -->
			<tr>
				<b>Stock Quote</b>
				<br />
				<td>@Endpoint Service class <input id="service" type="input"
					readonly="true" name="endpoint" size="50" value="StockService" />
				</td>
			</tr>
			<tr>
				<td>Method <input id="method" type="input" name="action"
					readonly="true" size="50" value="quote" />
				</td>
			</tr>
			<tr>
				<td>Enter Ticker Symbol Parameter<input id="ticker" type="input"
					name="ticker" size="50" value="GOOG" />
				</td>
			</tr>
			<tr>
				<td><input id="quote" type="submit" name="submit" /></td>
			</tr>
		</table>

		<!-- Add two numbers -->

		</br> <b>Add two numbers</b> </br>

			@Endpoint Service class <input type="input" id="testendpoint" name="endpoint" size="50" value="TestService" />
				 </br>
			 Method <input type="input" id="addmethod" name="method" size="50" value="add" /> 
			    </br>
			Number 1 <input type="input" id="x" name="x" size="50" />
			      </br>
			Number 2 <input type="input" id="y" name="y" size="50" />
			     </br> 
			<input id="add" type="submit" name="submit" />

		<br />
	    <br /> <b>Hello World Service</b> </br>

		<form enctype="multipart/form-data" method="get"
			action="SherpaServlet">

			@Endpoint Service class <input type="input" name="endpoint" size="50"
				value="TestService" /> </br> Method Name <input type="input"
				name="action" size="50" value="helloWorld" /> </br> <input type="submit"
				name="submit" />

		</form>
		
		


		<br /> <b>Get Authentication Token</b></br>
		<form enctype="multipart/form-data" method="get"
			action="SherpaServlet">
			Method <input id="action" type="input" name="action" size="50"
				value="authenticate" readonly="true" /> </br> User id <input id="userid"
				type="input" name="userid" size="50"
				value="dpitt@keyholesoftware.com" /> </br> Password <input id="password"
				type="input" name="password" size="50" value="password" /> </br> <input
				id="authenticate" type="submit" name="submit" />
		</form>
		<br /> <b>Invoke Authenticated Endpoint (Token Required)</b> </br>

		<form enctype="multipart/form-data" method="get"
			action="SherpaServlet">
			User id <input id="userid-a" type="input" name="userid" size="50"
				value="dpitt@keyholesoftware.com" readonly="true" /> </br> Enter Token <input
				id="token-a" type="input" name="token" size="50" /> </br> @Endpoint <input
				id="endpoint-a" type="input" name="endpoint" size="50"
				value="AuthenticatedService" /> </br> Method <input id="action-a"
				type="input" name="action" size="50" value="thirtyDays" /> </br> </br> <input
				id="authenticated-endpoint" type="submit" name="submit" />
		</form>

	


		</br> <b>Reverse service example</b></br>
		<form enctype="multipart/form-data" method="get"
			action="SherpaServlet">

			@Endpoint Service class <input type="input" name="endpoint" size="50"
				value="TestService" /> </br> Method Name <input type="input"
				name="action" size="50" value="reverse" /> </br> Parameter <input
				type="input" name="value" size="50" /> </br> <input type="submit"
				name="submit" />

		</form>

		
		</br>


	</div>
</div>














