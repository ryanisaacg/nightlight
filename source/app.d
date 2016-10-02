import arcade.geom;
import derelict.sdl2.sdl;

import entity;
import logic;
import io;

void main() {
    auto window = Window("Project Nightlight");
    
    SDL_Texture *block = window.load("img/block.bmp");
    SDL_Texture *player = window.load( "img/player.bmp");
    
    State state = State(10);
    state.tiles = new Tiles();
    state.tiles.put(block, Vector2(100, 100));
    state.player = Entity(Rect(0, 0, 32, 32), Vector2(1, 1), player);
    state.add(Entity(Rect(0, 0, 32, 32), Vector2(1, 1), player));
    
    
    while(window.stayOpen) {
		window.checkEvents();
		tick(state);
		window.draw(state);
		SDL_Delay(16);
	}
    
}
