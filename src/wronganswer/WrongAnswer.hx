package wronganswer;

import haxe.Int64;

typedef CharOutData = #if java java.lang.StringBuilder #else StringBuf #end;

@:forward(length, toString)
abstract CharOut(CharOutData) from CharOutData {
	public inline function new(capacity:Int = 1024) {
		this = new CharOutData(#if java capacity #end);
	}

	public inline function str(s:String):CharOut
		return #if java this.append(s); #else addDynamic(s); #end

	public inline function int(v:Int):CharOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function float(v:Float):CharOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function int64(v:Int64):CharOut
		return #if java this.append(v); #else addDynamic(Std.string(v)); #end

	public inline function char(code:Int):CharOut {
		#if java
		return this.appendCodePoint(code);
		#else
		this.addChar(code);
		return this;
		#end
	}

	public inline function lf():CharOut
		return char("\n".code);

	public inline function space():CharOut
		return char(" ".code);

	public inline function flush():Void {
		#if js
		(untyped process).stdout.write(this.toString());
		#elseif sys
		Sys.print(this.toString());
		#else
		throw "Unsupported operation.";
		#end
	}

	public inline function flushln():Void {
		#if js
		(untyped process).stdout.write(this.toString() + "\n");
		#elseif sys
		Sys.println(this.toString());
		#else
		throw "Unsupported operation.";
		#end
	}

	#if !java
	inline function addDynamic(v:Dynamic):CharOut {
		this.add(v);
		return this;
	}
	#end
}
