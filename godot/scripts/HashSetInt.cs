using System;
using Godot;

public class HashSetInt : HashSetBase<int>
{
	public Godot.Collections.Array<int> AsGodotArray()
	{
		var array = new Godot.Collections.Array<int>();
		foreach (int i in hashset)
		{
			array.Add(i);
		}
		return array;
	}
}