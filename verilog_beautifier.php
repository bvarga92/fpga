<?php
	function highlight($src){
		/* mindenkepp sortoressel vegzodjon */
		if(substr($src,-1)!="\n") $src=$src."\n";
		/* kommenteket, sztringeket kigyujtjuk */
		$comm_str=array();
		$src=preg_replace_callback('/(\/\*.*?\*\/|\/\/.*?\n)/is',function($m) use(&$comm_str){$id="$".uniqid()."$"; $comm_str[$id] = '<span class="C">'.$m[1].'</span>'; return $id;},$src);
		$src=preg_replace_callback('/((?<!\\\)".*?(?<!\\\)")/is',function($m) use(&$comm_str){$id="$".uniqid()."$"; $comm_str[$id] = '<span class="S">'.$m[1].'</span>'; return $id;},$src);
		/* operatorok, delimiterek stb. */
		$src=preg_replace('/([\-\!\#\%\^\*\(\)\+\|\~\=\`\{\}\[\]\:\"\'<>\?\,\.\/\@\&]+)/','<span class="O">$1</span>',$src);	
		/* szamok */
		$src=preg_replace('/(?<!\w)(\d+|b[(0-1)xz]+|d\d+|o[(0-7)xz]+|h[\d(a-f)xz]+)(?!\w)/i','<span class="N">$1</span>',$src);		
		/* kulcsszavak */
		$src=preg_replace('/(?<!\w)(always|assign|automatic|begin|case|casex|casez|cell|config|deassign|default|defparam|design|disable|edge|else|end|endcase|endconfig|endfunction|endgenerate|endmodule|endprimitive|endspecify|endtable|endtask|event|for|force|forever|fork|function|generate|genvar|if|ifnone|incdir|include|initial|inout|input|instance|join|liblist|library|localparam|macromodule|module|negedge|noshowcancelled|output|parameter|posedge|primitive|pulsestyle_ondetect|pulsestyle_onevent|reg|release|repeat|scalared|showcancelled|signed|specify|specparam|strength|table|task|tri|tri0|tri1|triand|trior|wand|wor|trireg|unsigned|use|vectored|wait|while|wire)(?!\w)/','<span class="K">$1</span>',$src);
		/* fajlmuveletek */
		$src=preg_replace('/(?<!\w)(\$fopen|\$fclose|\$fdisplay|\$fwrite|\$fstrobe|\$fmonitor|\$readmemb|\$readmemh)(?!\w)/','<span class="F">$1</span>',$src);
		/* kommentek, sztringek vissza */
		$src=str_replace(array_keys($comm_str),array_values($comm_str),$src);
		/* tabulalas szokozzel */
		$src=str_replace("\t",'    ',$src);
		return $src;
	}
?>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Verilog Syntax Highlighter</title>
	    <style>
			code{
				display:block;
				overflow:auto;
				white-space:pre;
				word-wrap:normal;
				padding:1em;
				background-color:#FFFFFF;
				color:#000000;
				font:normal normal <?php echo empty($_POST)?"13":$_POST["fontsize"];?>px/1.4 Consolas,"Andale Mono WT","Andale Mono","Lucida Console","Lucida Sans Typewriter","DejaVu Sans Mono","Bitstream Vera Sans Mono","Liberation Mono","Nimbus Mono L",Monaco,"Courier New",Courier,Monospace;
			}
			code span.C {color:#008000}
			code span.S {color:#808080}
			code span.O {color:#000080}
			code span.N {color:#FF8000}
			code span.K {color:#0000FF}
			code span.F {color:#8000FF}
    </style>
</head>

<body>
	<form action=<?php echo "\"".$_SERVER["PHP_SELF"]."\""; ?> method="POST">
		<textarea rows="10" name="src" style="width:50%; height:350px;">
<?php echo empty($_POST)?"/* 1 kB block RAM */\nreg[7:0] ram[1023:0];\ninitial \$readmemh(\"init.dat\",ram);\n\nreg[7:0] rd_data;\nalways@(posedge clk)\n    if(rst)\n        rd_data<=0;\n    else\n    begin\n        if(wr_en) ram[wr_addr]<=wr_data;\n        rd_data<=ram[rd_addr];\n    end\n":$_POST["src"]; ?>
</textarea>
		<br/><br/>
		Betűméret: <select name="fontsize">
			<option value="11"<?php if(!(empty($_POST))&&($_POST["fontsize"]==11)): echo " selected"; endif; ?>>11</option>
			<option value="13"<?php if((empty($_POST))||($_POST["fontsize"]==13)): echo " selected"; endif; ?>>13</option>
			<option value="15"<?php if(!(empty($_POST))&&($_POST["fontsize"]==15)): echo " selected"; endif; ?>>15</option>
			<option value="17"<?php if(!(empty($_POST))&&($_POST["fontsize"]==17)): echo " selected"; endif; ?>>17</option>
			<option value="19"<?php if(!(empty($_POST))&&($_POST["fontsize"]==19)): echo " selected"; endif; ?>>19</option>
		</select> 
		<br/><br/>
		<input type="submit" value="Színezés" style="background-color:#4CAF50; color:#FFFFFF; padding: 10px 20px; font-size:16px;" />
	</form>
	<br/>
	<?php
		if(!empty($_POST)):
			$src=highlight($_POST['src']);
			echo "<code>\n".$src."\n\t</code>";
		endif;
	?>

</body>
</html>
