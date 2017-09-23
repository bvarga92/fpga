<?php
	function highlight($src){
		/* formazas: <>&" karakterek escape-elve, tabulalas torhetetlen szokozokkel, ujsor vegzodes */
		$src=htmlspecialchars($src,ENT_COMPAT);
		$src=str_replace("\t",'    ',$src);
		$src=str_replace(' ','&nbsp;',$src);
		if(substr($src,-1)!="\n") $src=$src."\n";
		/* kommenteket, sztringeket kigyujtjuk */
		$comm_str=array();
		$src=preg_replace_callback('/(\/\*.*?\*\/|\/\/.*?\n)/is',function($m) use(&$comm_str){$id="$".uniqid()."$"; $comm_str[$id] = '<span style="color:green">'.$m[1].'</span>'; return $id;},$src);
		$src=preg_replace_callback('/((?<!\\\)&quot;.*?(?<!\\\)&quot;)/is',function($m) use(&$comm_str){$id="$".uniqid()."$"; $comm_str[$id] = '<span style="color:gray">'.$m[1].'</span>'; return $id;},$src);
		/* operatorok, delimiterek stb. */
		$src=preg_replace('/([\-\!\%\^\*\(\)\+\|\#\~\=\{\}\[\]\:\'\?\,\.\/\@]+|&lt;|&gt;|&amp;)/','<span style="color:navy">$1</span>',$src);
		/* szamok */
		$src=preg_replace('/(?<!\w)([\d_]+|b[(0-1)xz_]+|d[\d_]+|o[(0-7)xz_]+|h[\d(a-f)xz_]+)(?!\w)/i','<span style="color:#FF8000">$1</span>',$src);		
		/* kulcsszavak */
		$src=preg_replace('/(?<!\w)(always|assign|automatic|begin|case|casex|casez|cell|config|deassign|default|defparam|design|disable|edge|else|end|endcase|endconfig|endfunction|endgenerate|endmodule|endprimitive|endspecify|endtable|endtask|event|for|force|forever|fork|function|generate|genvar|if|ifnone|initial|inout|input|instance|integer|join|liblist|library|localparam|macromodule|module|negedge|noshowcancelled|output|parameter|posedge|primitive|pulsestyle_ondetect|pulsestyle_onevent|reg|release|repeat|scalared|showcancelled|signed|specify|specparam|strength|table|task|tri|tri0|tri1|triand|trior|wand|wor|trireg|unsigned|use|vectored|wait|while|wire)(?!\w)/','<span style="color:blue;">$1</span>',$src);
		/* fajlmuveletek, direktivak stb. */
		$src=preg_replace('/(?<!\w)(\$fopen|\$fclose|\$fdisplay|\$fwrite|\$fstrobe|\$fmonitor|\$readmemb|\$readmemh|\$display|\$clog2|\$bits|\$finish|\$write|\$monitor|`define|`undef|`ifdef|`ifndef|`else|`elsif|`endif|`line|`timescale|`include|`celldefine|`endcelldefine|`default_nettype|`resetall|`unconnected_drive|`nuunconnected_drive|`default_decay_time|`default_trireg_strength|`delay_mode_distributed|`delay_mode_path|`delay_mode_unit|`delay_mode_zero)(?!\w)/','<span style="color:#8000FF">$1</span>',$src);
		/* kommentek, sztringek vissza */
		$src=str_replace(array_keys($comm_str),array_values($comm_str),$src);
		/* sortoresek */
		$src=nl2br($src);
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
				word-wrap:normal;
				padding:1em;
				background-color:#FFFFFF;
				color:#000000;
				font:normal normal <?php echo empty($_POST)?"13":$_POST["fontsize"];?>px/1.4 Consolas,"Andale Mono WT","Andale Mono","Lucida Console","Lucida Sans Typewriter","DejaVu Sans Mono","Bitstream Vera Sans Mono","Liberation Mono","Nimbus Mono L",Monaco,"Courier New",Courier,Monospace;
			}
    </style>
</head>

<body>
	<form action=<?php echo "\"".$_SERVER["PHP_SELF"]."\""; ?> method="POST">
		<textarea rows="10" name="src" style="width:50%; height:350px;">
<?php echo empty($_POST)?"/* 1 kB block RAM */\nreg[7:0] ram[1023:0];\ninitial \$readmemh(\"init.dat\",ram);\n\nreg[7:0] rd_data;\nalways@(posedge clk)\n    if(rst)\n        rd_data<=0;\n    else\n    begin\n        if(wr_en) ram[wr_addr]<=wr_data;\n        rd_data<=ram[rd_addr];\n    end\n":htmlspecialchars($_POST["src"]); ?>
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
