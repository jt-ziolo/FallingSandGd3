using System.Collections.Generic;
using Godot;

// Implemented as a simple wrapper around the standard
// System.Collections.Generic HashSet 
public class CoordinateHashSet : Node
{
	private HashSet<KeyValuePair<int, int>> hashset = new HashSet<KeyValuePair<int, int>>();

	public HashSet<KeyValuePair<int, int>> Hashset { get => hashset; private set => hashset = value; }

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
	public void Add(Godot.Collections.Array<int> array)
	{
		int x = array[0];
		int y = array[1];
		this.Add(x, y);
	}
	public void Remove(Godot.Collections.Array<int> array)
	{
		int x = array[0];
		int y = array[1];
		this.Remove(x, y);
	}
	public bool Contains(Godot.Collections.Array<int> array)
	{
		int x = array[0];
		int y = array[1];
		return this.Contains(x, y);
	}
	public void Clear()
	{
		hashset.Clear();
	}
	public void UnionWith(CoordinateHashSet other)
	{
		Hashset.UnionWith(other.Hashset);
	}
	public void IntersectWith(CoordinateHashSet other)
	{
		Hashset.IntersectWith(other.Hashset);
	}
	public void ExceptWith(CoordinateHashSet other)
	{
		Hashset.ExceptWith(other.Hashset);
	}
	public void SymmetricExceptWith(CoordinateHashSet other)
	{
		Hashset.SymmetricExceptWith(other.Hashset);
	}
	public void IsSubsetOf(CoordinateHashSet other)
	{
		Hashset.IsSubsetOf(other.Hashset);
	}
	public void IsProperSubsetOf(CoordinateHashSet other)
	{
		Hashset.IsProperSubsetOf(other.Hashset);
	}
	public void IsSupersetOf(CoordinateHashSet other)
	{
		Hashset.IsSupersetOf(other.Hashset);
	}
	public void IsProperSupersetOf(CoordinateHashSet other)
	{
		Hashset.IsProperSupersetOf(other.Hashset);
	}
	public void SetEquals(CoordinateHashSet other)
	{
		Hashset.SetEquals(other.Hashset);
	}
}
