import arcade.geom;
import entity;
import derelict.sdl2.sdl;

struct Renderer {
	SDL_Texture *texture;
	SDL_Renderer *renderer;
	
	void draw(State state) {
		foreach(entity; state.entities) {
			SDL_Rect target = convert(entity.bounds);
			SDL_RenderCopy(renderer, texture, null, &target);
		}
	}
	
	private SDL_Rect convert(Rect rect) {
		return SDL_Rect(cast(int)rect.x, cast(int)rect.y, cast(int)rect.width, cast(int)rect.height);
	}
}
