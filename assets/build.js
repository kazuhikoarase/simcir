!function() {

	var getMimeType = function() {

		var defaultMimeType = 'application/octet-stream';
		
		var mimeTypes = {
			'^.*\\.(txt|c|cpp|h|hpp|php|pl|sh|bat|vbs|wsf|java|MF|scala|as|mxml|xml|xsd|xsl|xsi|xmi|properties|jsp|jspx|tag|tagx|sql)$': 'text/plain',
			'^.*\\.(html|htm)$': 'text/html',
			'^.*\\.js$': 'text/javascript',
			'^.*\\.css$': 'text/css',
			'^.*\\.pdf$': 'application/pdf',
			'^.*\\.jpg$': 'image/jpeg',
			'^.*\\.gif$': 'image/gif',
			'^.*\\.png$': 'image/png'
		};

		return function(name) {
			for (var pattern in mimeTypes) {
				if (name.match(new RegExp(pattern) ) ) {
					return mimeTypes[pattern];
				}
			}
			return defaultMimeType;
		};
	}();
	
	var trace = function(msg) {
		java.lang.System.out.println('' + msg);
	};
				
	var File = Packages.java.io.File;
	
	var fs = project.getReference('fs');
	var ds = fs.getDirectoryScanner(project);
	var srcFiles = ds.getIncludedFiles();
	
	for (var i = 0; i < srcFiles.length; i += 1) {
		var file = new File(fs.getDir(project), srcFiles[i]);
		var antcall = project.createTask('antcall');
		var addParam = function(k, v) {
			var param = antcall.createParam();
			param.setName(k);
			param.setValue(v);
		};
		addParam('path', file.getPath() );
		addParam('mimeType', getMimeType(file.getName() ) );
		antcall.setTarget('propset');
		antcall.perform();
	}
	
}();

