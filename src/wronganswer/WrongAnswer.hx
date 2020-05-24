package wronganswer;

import haxe.Int64;

typedef StdOutData = #if java java.lang.StringBuilder #else StringBuf #end;

@:forward(length, toString)
abstract StdOut(StdOutData) from StdOutData {
	public inline function new(capacity:Int = 1024) {
		this = new StdOutData(#if java capacity #end);
	}

	public inline function str(s:String):StdOut
		return #if java this.append(s); #else addDynamic(s); #end

	public inline function int(v:Int):StdOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function float(v:Float):StdOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function int64(v:Int64):StdOut
		return #if java this.append(v); #else addDynamic(Std.string(v)); #end

	public inline function char(code:Int):StdOut {
		#if java
		return this.appendCodePoint(code);
		#else
		this.addChar(code);
		return this;
		#end
	}

	public inline function lf():StdOut
		return char("\n".code);

	public inline function space():StdOut
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
	inline function addDynamic(v:Dynamic):StdOut {
		this.add(v);
		return this;
	}
	#end
}
