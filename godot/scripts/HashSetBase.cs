using System.Collections.Generic;
using Godot;

public abstract class HashSetBase<T> : Node where T : struct
{
	protected HashSet<T> hashset = new HashSet<T>();

	public HashSet<T> Hashset { get => hashset; private set => hashset = value; }

	public void Clear()
	{
		hashset.Clear();
	}
	public void Add(T item)
	{
		hashset.Add(item);
	}
	public void Remove(T item)
	{
		hashset.Remove(item);
	}
	public bool Contains(T item)
	{
		return hashset.Contains(item);
	}
	/* Make sure that the two hash sets compared are for like types
	public void ExceptWith(HashSetBase<T> other)
	{
		Hashset.ExceptWith(other.Hashset);
	}
	public void IntersectWith(HashSetBase<T> other)
	{
		Hashset.IntersectWith(other.Hashset);
	}
	public void IsProperSubsetOf(HashSetBase<T> other)
	{
		Hashset.IsProperSubsetOf(other.Hashset);
	}
	public void IsProperSupersetOf(HashSetBase<T> other)
	{
		Hashset.IsProperSupersetOf(other.Hashset);
	}
	public void IsSubsetOf(HashSetBase<T> other)
	{
		Hashset.IsSubsetOf(other.Hashset);
	}
	public void IsSupersetOf(HashSetBase<T> other)
	{
		Hashset.IsSupersetOf(other.Hashset);
	}
	public void SetEquals(HashSetBase<T> other)
	{
		Hashset.SetEquals(other.Hashset);
	}
	public void SymmetricExceptWith(HashSetBase<T> other)
	{
		Hashset.SymmetricExceptWith(other.Hashset);
	}
	public void UnionWith(HashSetBase<T> other)
	{
		Hashset.UnionWith(other.Hashset);
	}
	*/
}