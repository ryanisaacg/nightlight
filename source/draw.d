import arcade.geom;
import entity;
import derelict.sdl2.sdl;
import std.stdio;

struct Renderer {
	SDL_Renderer *renderer;
	
	void draw(State state) {
		foreach(entity; state.entities) {
			SDL_Rect target = convert(entity.bounds);
			SDL_RenderCopy(renderer, entity.texture, null, &target);
		}
		for(int x = 0; x < state.tiles.width; x += 32) {
			for(int y = 0; y < state.tiles.height; y += 32) {
				auto tex = state.tiles.get(Vector2(x, y));
				if(!tex.isNull) {
					SDL_Rect target = SDL_Rect(x, y, 32, 32);
					SDL_RenderCopy(renderer, tex, null, &target);
				}
			}
		}
	}
	
	private SDL_Rect convert(Rect rect) {
		return SDL_Rect(cast(int)rect.x, cast(int)rect.y, cast(int)rect.width, cast(int)rect.height);
	}
}
