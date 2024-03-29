using System.Collections.Generic;
using Godot;

public class HashSetPoint : HashSetBase<KeyValuePair<int, int>>
{
	public void Add(int x, int y)
	{
		KeyValuePair<int, int> pair = new KeyValuePair<int, int>(x, y);
		hashset.Add(pair);
	}
	public void Remove(int x, int y)
	{
		KeyValuePair<int, int> pair = new KeyValuePair<int, int>(x, y);
		hashset.Remove(pair);
	}
	public bool Contains(int x, int y)
	{
		KeyValuePair<int, int> pair = new KeyValuePair<int, int>(x, y);
		return hashset.Contains(pair);
	}
	public Vector2[] GetAsVec2Array()
	{
		Vector2[] result = new Vector2[Hashset.Count];
		int index = 0;
		foreach (KeyValuePair<int, int> entry in Hashset)
		{
			result[index] = new Vector2(entry.Key, entry.Value);
			index++;
		}
		return result;
	}
}
