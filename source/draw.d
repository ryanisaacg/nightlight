import arcade.geom;
import multimedia.graphics;

import entity;

Texture effectTex;

void drawState(Window window, State state) {
    if(effectTex.texture == null) 
        effectTex = Texture(window.draw, window.width, window.height, true);
    Renderer draw = window.draw;
    //Draw the lighting created by the entities
    void lighting_overlay(Entity highlight) {
		//Set up render state
        draw.setTarget(effectTex);
        draw.mode = BlendMode.None;
        draw.setColor(cast(byte)0, cast(byte)0, cast(byte)0, cast(byte)230);
		draw.fillRect(0, 0, window.width, window.height);
		//Render the blackened area
		//Render the highlighted area
		//TODO: Render in circle
		Rect bounds = highlight.bounds;
        int[3] alphas = [200, 128, 0]; // the alphas of each level of shadow
        for(int i = 0; i < 3; i ++) {
            draw.setColor(cast(byte)0, cast(byte)0, cast(byte)0, cast(byte)alphas[i]);
            int off = 90 - i * 30; //the offset of the lighting size
            draw.fillRect(cast(int)bounds.x - off, cast(int)bounds.y - off, 
                cast(int)bounds.width + off * 2, cast(int)bounds.height + off * 2);
        }
		//Draw the effect target over the screen
		draw.resetTarget();
        draw.mode = BlendMode.Blend;
        draw.draw(effectTex, 0, 0, window.width, window.height);
	}
    //Draw the window background
    draw.setColor(cast(byte)128, cast(byte)128, cast(byte)128, cast(byte)255);
    draw.clear();
    //Draw the entities
    for(int i = 0; i < state.amount; i++) {
        Entity e = state.entities[i];
        draw.draw(e.texture, cast(int)e.bounds.x, cast(int)e.bounds.y, cast(int)e.bounds.width, cast(int)e.bounds.height);
    }
    //Draw the tiles
    for(int x = 0; x < state.tiles.width; x += 32) {
        for(int y = 0; y < state.tiles.height; y += 32) {
            auto tex = state.tiles.get(Vector2(x, y));
            if(!tex.isNull)
                draw.draw(tex, x, y, 32, 32);
        }
    }
    //Draw the lighting
   // lighting_overlay(state.entities[0]);
    //Finish drawing
    draw.display();
}