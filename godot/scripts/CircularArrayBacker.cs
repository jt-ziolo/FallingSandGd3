using Godot;
using System;

public class CircularArrayBacker : Node
{
	private int _count = 0;
	private int _initial_index = 0;
	private int _current_index = 0;

	public void Start(int count, int initial_index)
	{
		_count = count;
		_initial_index = initial_index;
		_current_index = _initial_index;
	}

	public void StartForArray(Godot.Collections.Array array)
	{
		_count = array.Count;
		_initial_index = 0;
		_current_index = _initial_index;
	}

	private void Adjust()
	{
		if (_current_index < 0)
		{
			_current_index = _count - 1;
			return;
		}
		if (_current_index >= _count)
		{
			_current_index = 0;
		}
	}
	public int GoForwardOnce()
	{
		return GoForward(1);
	}
	public int GoBackwardOnce()
	{
		return GoBackward(1);
	}
	public int GoForward(int times)
	{
		for (int i = 0; i < times; i++)
		{
			_current_index += 1;
			Adjust();
		}
		return _current_index;
	}
	public int GoBackward(int times)
	{
		for (int i = 0; i < times; i++)
		{
			_current_index -= 1;
			Adjust();
		}
		return _current_index;
	}
}
