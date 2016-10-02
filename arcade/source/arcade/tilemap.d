module arcade.map;

import std.math;
import std.typecons;
import arcade.geom;

/**
 * A tiled map of items
 * T- the item type
 * width, height, and tileSize define the grid bounds
 */
class Tilemap(T, int width, int height, int tileSize) {
	//The grid data
	private Nullable!T[height][width] data;
	
	//Converts a Vector2 to data grid coordinates
	pure private void convert(Vector2 vec, out int x, out int y) {
		x = cast(int)(vec.x / tileSize);
		y = cast(int)(vec.y / tileSize);
	}
	
	//Do an action at a point
	template do_point(alias func) {
		private auto do_point(Vector2 point) {
			int x, y;
			convert(point, x, y);
			return func(x, y);
		}
	}
	
	//Do a paramterized action at a point
	template do_point(alias func, Type) {
		private auto do_point(Vector2 point, Type item) {
			int x, y;
			convert(point, x, y);
			return func(x, y, item);
		}
	}
	
	//Do an action over a region
	template do_region(alias func) {
		auto do_region(Rect region) {
			//If the region is smaller than a grid square, make sure it still gets checked at all corners
			float incr_x = fmin(region.width, tileSize);
			float incr_y = fmin(region.height, tileSize);
			for(float x = region.x; x <= region.x + region.width + tileSize; x += incr_x) {
				for(float y = region.y; y <= region.y + region.height + tileSize; y += incr_y) {
					Vector2 point = Vector2(x, y);
					//Don't check against points outside of the region
					if(region.contains(point)) {
						do_point!func(point);
					}
				}
			}
			
		}
	}
	
	//Do a parameterized action over a region
	template do_region(alias func, Type) {
		auto do_region(Rect region, Type item) {
			//If the region is smaller than a grid square, make sure it still gets checked at all corners
			float incr_x = fmin(region.width, tileSize);
			float incr_y = fmin(region.height, tileSize);
			for(float x = region.x; x <= region.x + region.width + tileSize; x += incr_x) {
				for(float y = region.y; y <= region.y + region.height + tileSize; y += incr_y) {
					Vector2 point = Vector2(x, y);
					//Don't check against points outside of the region
					if(region.contains(point)) {
						do_point!func(point, item);
					}
				}
			}
		}
	}
	
	private void put_array(int x, int y, T element) { data[x][y] = element; }
	///Put an item into the grid at a point
	void put(T item, Vector2 point) { do_point!put_array(point, item); }
	///Put an item into the grid over an area
	void put(T item, Rect area) { do_region!put_array(area, item); }
	
	private void remove_array(int x, int y) { data[x][y].nullify(); }
	///Remove an item from a point
	void remove(Vector2 point) { do_point!remove_array(point); }
	///Remove an item from a region
	void remove(Rect area) { do_region!remove_array(area); }
	
	private void is_empty_array(int x, int y, bool *empty) { *empty &= data[x][y].isNull(); }
	///Check if a point is empty
	bool is_empty(Vector2 point) { bool empty = true; do_point!is_empty_array(point, &empty); return empty; }
	///Check if a region is empty
	bool is_empty(Rect area) { bool empty = true; do_region!is_empty_array(area, &empty); return empty; }
	
	///Get the elements at a point
	private Nullable!T get_array(int x, int y) { return data[x][y]; }
	pure Nullable!T get(Vector2 point) { return do_point!get_array(point); }
	
	/** Move a rectangle at a speed
	 * If there is a non-empty spot in the way, stop the movement and return that stopped position and displacement
	 * Precondition: area is a free rectangle
	 * Postcondition: end_area is a free rectangle
	 */
	 void move(Rect area, Vector2 speed, out Rect end_area, out Vector2 end_speed) {
		 //If the rect isn't free, the whole thing is invalid
		if(!is_empty(area)) return;
		//Move the rectangle, decreasing the displacement each attempt
		Vector2 change = -Vector2(sgn(speed.x), sgn(speed.y));
		while(speed.len > 0) {
			Rect attempt = area.move(speed);
			if(is_empty(attempt)) {
				end_area = attempt;
				speed = speed;
				return;
			} else if(speed.len < 1) {
				end_area = area;
				speed = speed;
				return;
			}
			speed = speed + change;
		}
	}
}
