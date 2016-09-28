/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file background.c
 *
 * @brief Handles displaying backgrounds.
 */

#include "background.h"

#include "naev.h"

#include "nxml.h"

#include "opengl.h"
#include "log.h"
#include "player.h"
#include "conf.h"
#include "rng.h"
#include "pause.h"
#include "array.h"
#include "ndata.h"
#include "nlua.h"
#include "nluadef.h"
#include "nlua_tex.h"
#include "nlua_col.h"
#include "nlua_bkg.h"
#include "camera.h"
#include "nebula.h"
#include "nstring.h"


/**
 * @brief Represents a background image like say a Nebula.
 */
typedef struct background_image_s {
   unsigned int id; /**< Background id. */
   glTexture *image; /**< Image to display. */
   double x; /**< X center of the image. */
   double y; /**< Y center of the image. */
   double move; /**< How many pixels it moves for each pixel the player moves. */
   double scale; /**< How the image should be scaled. */
   glColour col; /**< Colour to use. */
} background_image_t;
static background_image_t *bkg_image_arr_bk = NULL; /**< Background image array to display (behind stars). */
static background_image_t *bkg_image_arr_ft = NULL; /**< Background image array to display (in front of stars). */


static unsigned int bkg_idgen = 0; /**< ID generator for backgrounds. */


/**
 * @brief Backgrounds.
 */
static nlua_env bkg_cur_env = LUA_NOREF; /**< Current Lua state. */
static nlua_env bkg_def_env = LUA_NOREF; /**< Default Lua state. */


/*
 * Background stars.
 */
#define STAR_BUF     500 /**< Area to leave around screen for stars, more = less repetition */
static gl_vbo *star_vertexVBO_small = NULL; /**< Star Vertex VBO. */
static gl_vbo *star_colourVBO_small = NULL; /**< Star Colour VBO. */
static gl_vbo *star_vertexVBO_med = NULL; /**< Star Vertex VBO. */
static gl_vbo *star_colourVBO_med = NULL; /**< Star Colour VBO. */
static gl_vbo *star_vertexVBO_large = NULL; /**< Star Vertex VBO. */
static gl_vbo *star_colourVBO_large = NULL; /**< Star Colour VBO. */


static GLfloat *star_original_pos = NULL; /** original position of the stars **/
static double *star_moves = NULL; /* move value of each star */
static GLfloat *star_vertex = NULL; /**< Vertex of the stars. */
static GLfloat *star_colour = NULL; /**< Brightness and colour of the stars. */
static unsigned int nstars = 0; /**< Total stars. */
static unsigned int nstars_small = 0; /**< Total small stars. */
static unsigned int nstars_med = 0; /**< Total med stars. */
static unsigned int nstars_large = 0; /**< Total large stars. */
static unsigned int mstars = 0; /**< Memory stars are taking. */

/*
 * Prototypes.
 */
static void background_renderImages( background_image_t *bkg_arr );
static nlua_env background_create( const char *path );
static void background_clearCurrent (void);
static void background_clearImgArr( background_image_t **arr );
/* Sorting. */
static int bkg_compare( const void *p1, const void *p2 );
static void bkg_sort( background_image_t *arr );
static void background_renderStars_renderSize(gl_vbo* star_vertexVBO,gl_vbo* star_colourVBO,int shade_mode,
		int n, int width);

/**
 * @brief Initializes background stars.
 *
 *    @param n Number of stars to add (stars per 800x640 screen).
 */
void background_initStars( int n )
{
   unsigned int i;
   double r;
   GLfloat w, h, hw, hh;
   double size;

   /* Calculate size. */
   size  = SCREEN_W*SCREEN_H+STAR_BUF*STAR_BUF;

   /* Calculate star buffer. */
   w  = (SCREEN_W + 2.*STAR_BUF);
   h  = (SCREEN_H + 2.*STAR_BUF);
   hw = w / 2.;
   hh = h / 2.;

   /* Calculate stars. */
   size  *= n;
   nstars = (unsigned int)(size/(800.*600.));

   if (mstars < nstars) {
      /* Create data. */
      star_vertex = realloc( star_vertex, nstars * sizeof(GLfloat) * 4 );
      star_colour = realloc( star_colour, nstars * sizeof(GLfloat) * 8 );
      star_original_pos = realloc( star_original_pos, nstars * sizeof(GLfloat) * 2 );
      star_moves = realloc( star_moves, nstars * sizeof(double) );
      mstars = nstars;
   }

   nstars_small=nstars*0.6;
   nstars_med=nstars*0.3;
   nstars_large=nstars-nstars_small-nstars_med;

   for (i=0; i < nstars; i++) {
      /* Set the position. */
	  star_moves[i] = 0.01+RNGF()*0.05;
	  star_original_pos[2*i+0] = (RNGF()*2-1)*hw;
	  star_original_pos[2*i+1] = (RNGF()*2-1)*hh;
      star_vertex[4*i+0] = star_original_pos[2*i+0];
      star_vertex[4*i+1] = star_original_pos[2*i+1];
      star_vertex[4*i+2] = 0.;
      star_vertex[4*i+3] = 0.;
      /* Set the colour. */
      r=RNGF();
      if (r<0.4) {//white
    	  star_colour[8*i+0] = 1;
    	  star_colour[8*i+1] = 1;
    	  star_colour[8*i+2] = 1;
    	  star_colour[8*i+3] = RNGF()*0.8 + 0.2;
      } else if (r<0.6) {//red
    	  star_colour[8*i+0] = 1;
    	  star_colour[8*i+1] = 0.9;
    	  star_colour[8*i+2] = 0.9;
    	  star_colour[8*i+3] = RNGF()*0.6 + 0.2;
      } else if (r<0.8) {//blueish
    	  star_colour[8*i+0] = 0.8;
    	  star_colour[8*i+1] = 1;
    	  star_colour[8*i+2] = 1;
    	  star_colour[8*i+3] = RNGF()*0.8 + 0.2;
      } else {//yellowish
    	  star_colour[8*i+0] = 1;
    	  star_colour[8*i+1] = 1;
    	  star_colour[8*i+2] = 0.8;
    	  star_colour[8*i+3] = RNGF()*0.8 + 0.2;
      }
      star_colour[8*i+4] = 1.;
      star_colour[8*i+5] = 1.;
      star_colour[8*i+6] = 1.;
      star_colour[8*i+7] = 0.;
   }

   /* Destroy old VBO. */
   if (star_vertexVBO_small != NULL) {
	   gl_vboDestroy( star_vertexVBO_small );
	   star_vertexVBO_small = NULL;
   }
   if (star_colourVBO_small != NULL) {
	   gl_vboDestroy( star_colourVBO_small );
	   star_colourVBO_small = NULL;
   }
   if (star_vertexVBO_med != NULL) {
	   gl_vboDestroy( star_vertexVBO_med );
	   star_vertexVBO_med = NULL;
   }
   if (star_colourVBO_med != NULL) {
	   gl_vboDestroy( star_colourVBO_med );
	   star_colourVBO_med = NULL;
   }
   if (star_vertexVBO_large != NULL) {
	   gl_vboDestroy( star_vertexVBO_large );
	   star_vertexVBO_large = NULL;
   }
   if (star_colourVBO_large != NULL) {
	   gl_vboDestroy( star_colourVBO_large );
	   star_colourVBO_large = NULL;
   }

   /* Create now VBO. */
   star_vertexVBO_small = gl_vboCreateStream(
         nstars_small * sizeof(GLfloat) * 4, star_vertex );
   star_colourVBO_small = gl_vboCreateStatic(
		   nstars_small * sizeof(GLfloat) * 8, star_colour );

   star_vertexVBO_med = gl_vboCreateStream(
		   nstars_med * sizeof(GLfloat) * 4, &star_vertex[nstars_small*4] );
   star_colourVBO_med = gl_vboCreateStatic(
		   nstars_med * sizeof(GLfloat) * 8, &star_colour[nstars_small*8] );

   star_vertexVBO_large = gl_vboCreateStream(
		   nstars_large * sizeof(GLfloat) * 4, &star_vertex[(nstars_small+nstars_med)*4] );
   star_colourVBO_large = gl_vboCreateStatic(
		   nstars_large * sizeof(GLfloat) * 8, &star_colour[(nstars_small+nstars_med)*8] );
}


/**
 * @brief Displaces the stars, useful with camera.
 */
void background_moveStars( double x, double y )
{
   //star_x += (GLfloat) x;
   //star_y += (GLfloat) y;

   /* Puffs also need moving. */
   nebu_movePuffs( x, y );
}

static void background_renderStars_renderSize(gl_vbo* star_vertexVBO,gl_vbo* star_colourVBO,int shade_mode,
		int n, int width) {
	glPointSize(width);
	glLineWidth(width);
	gl_vboActivate(star_vertexVBO, GL_VERTEX_ARRAY, 2, GL_FLOAT,
			2 * sizeof(GLfloat));
	gl_vboActivate(star_colourVBO, GL_COLOR_ARRAY, 4, GL_FLOAT,
			4 * sizeof(GLfloat));
	if (shade_mode) {
		glDrawArrays(GL_LINES, 0, n);
		glDrawArrays(GL_POINTS, 0, n); /* This second pass is when the lines are very short that they "lose" intensity. */
		glShadeModel(GL_FLAT);
	} else
		glDrawArrays(GL_POINTS, 0, n);
}

/**
 * @brief Renders the starry background.
 *
 * This could really benefit from OpenCL directly. It would probably give a great
 *  speed up, although we'll consider it when we get a runtime linking OpenCL
 *  framework someday.
 *
 *    @param dt Current delta tick.
 */
void background_renderStars( const double dt )
{
   (void) dt;
   unsigned int i;
   GLfloat h, w;
   GLfloat x, y, m;
   GLfloat brightness;
   int shade_mode;
   double px,py;
   int vertex_change=0;

   /*
    * gprof claims it's the slowest thing in the game!
    */

   gl_matrixPush();
   gl_matrixTranslate( SCREEN_W/2., SCREEN_H/2. );

   if (!paused && (player.p != NULL) && !player_isFlag(PLAYER_DESTROYED) &&
         !player_isFlag(PLAYER_CREATING)) { /* update position */

      /* Calculate some dimensions. */
      w  = (SCREEN_W + 2.*STAR_BUF);
      w += conf.zoom_stars * (w / conf.zoom_far - 1.);
      h  = (SCREEN_H + 2.*STAR_BUF);
      h += conf.zoom_stars * (h / conf.zoom_far - 1.);

      cam_getPos( &px, &py );

      /* Calculate new star positions. */
      for (i=0; i < nstars; i++) {

    	  x  = (star_original_pos[2*i+0] - px * star_moves[i]);
    	  y  = (star_original_pos[2*i+1] - py * star_moves[i]);

    	  /* Calculate new position */
    	  star_vertex[4*i+0] = x;
    	  star_vertex[4*i+1] = y;
      }

      vertex_change=1;
   }

   /* Decide on shade mode. */
   shade_mode = 0;
   if ((player.p != NULL) && !player_isFlag(PLAYER_DESTROYED) &&
         !player_isFlag(PLAYER_CREATING)) {

      if (pilot_isFlag(player.p,PILOT_HYPERSPACE)) { /* hyperspace fancy effects */

         glShadeModel(GL_SMOOTH);
         shade_mode = 1;

         /* lines get longer the closer we are to finishing the jump */
         m  = MAX( 0, HYPERSPACE_STARS_BLUR-player.p->ptimer );
         m /= HYPERSPACE_STARS_BLUR;
         m *= HYPERSPACE_STARS_LENGTH;
         x = m*cos(VANGLE(player.p->solid->vel));
         y = m*sin(VANGLE(player.p->solid->vel));
      }
      else if (dt_mod * VMOD(player.p->solid->vel) > 500. ){

         glShadeModel(GL_SMOOTH);
         shade_mode = 1;

         /* Very short lines tend to flicker horribly. A stock Llama at 2x
          * speed just so happens to make very short lines. A 5px minimum
          * is long enough to (mostly) alleviate the flickering.
          */
         m = MAX( 5, dt_mod*VMOD(player.p->solid->vel)/25. - 20 );
         x = m*cos(VANGLE(player.p->solid->vel));
         y = m*sin(VANGLE(player.p->solid->vel));
      }

      if (shade_mode) {
         /* Generate lines. */
         for (i=0; i < nstars; i++) {
            brightness = star_colour[8*i+3];
            star_vertex[4*i+2] = star_vertex[4*i+0] + x*brightness*star_moves[i]*50;
            star_vertex[4*i+3] = star_vertex[4*i+1] + y*brightness*star_moves[i]*50;

            vertex_change=1;
         }
      }
   }

   if (vertex_change) {
	   /* Upload new data. */
	   gl_vboSubData( star_vertexVBO_small, 0, nstars_small * 4 * sizeof(GLfloat), star_vertex );
	   gl_vboSubData( star_vertexVBO_med, 0, nstars_med * 4 * sizeof(GLfloat), &star_vertex[nstars_small*4] );
	   gl_vboSubData( star_vertexVBO_large, 0, nstars_large * 4 * sizeof(GLfloat), &star_vertex[(nstars_small+nstars_med)*4] );
   }

   /* Render. */
   glEnable( GL_POINT_SMOOTH );
   glEnable( GL_LINE_SMOOTH );

   background_renderStars_renderSize(star_vertexVBO_small, star_colourVBO_small, shade_mode, nstars_small,1);
   background_renderStars_renderSize(star_vertexVBO_med, star_colourVBO_med, shade_mode, nstars_med,2);
   background_renderStars_renderSize(star_vertexVBO_large, star_colourVBO_large, shade_mode, nstars_large,3);

   /* Disable vertex array. */
   gl_vboDeactivate();

   glPointSize(1.0f);
   glLineWidth(1.0f);

   /* Pop matrix. */
   gl_matrixPop();

   /* Check for errors. */
   gl_checkErr();
}


/**
 * @brief Render the background.
 */
void background_render( double dt )
{
   background_renderImages( bkg_image_arr_bk );
   background_renderStars(dt);
   background_renderImages( bkg_image_arr_ft );
}


/**
 * @brief Compares two different backgrounds and sorts them.
 */
static int bkg_compare( const void *p1, const void *p2 )
{
   background_image_t *bkg1, *bkg2;

   bkg1 = (background_image_t*) p1;
   bkg2 = (background_image_t*) p2;

   if (bkg1->move < bkg2->move)
      return -1;
   else if (bkg1->move > bkg2->move)
      return +1;
   return  0;
}


/**
 * @brief Sorts the backgrounds by movement.
 */
static void bkg_sort( background_image_t *arr )
{
   qsort( arr, array_size(arr), sizeof(background_image_t), bkg_compare );
}


/**
 * @brief Adds a new background image.
 */
unsigned int background_addImage( glTexture *image, double x, double y,
      double move, double scale, const glColour *col, int foreground )
{
   background_image_t *bkg, **arr;

   if (foreground)
      arr = &bkg_image_arr_ft;
   else
      arr = &bkg_image_arr_bk;

   /* See if must create. */
   if (*arr == NULL)
      *arr = array_create( background_image_t );

   /* Create image. */
   bkg         = &array_grow( arr );
   bkg->id     = ++bkg_idgen;
   bkg->image  = gl_dupTexture(image);
   bkg->x      = x;
   bkg->y      = y;
   bkg->move   = move;
   bkg->scale  = scale;
   bkg->col    = (col!=NULL) ? *col : cWhite;

   /* Sort if necessary. */
   bkg_sort( *arr );

   return bkg_idgen;
}


/**
 * @brief Renders the background images.
 */
static void background_renderImages( background_image_t *bkg_arr )
{
   int i;
   background_image_t *bkg;
   double px,py, x,y, xs,ys, z;

   /* Must have an image array created. */
   if (bkg_arr == NULL)
      return;

   /* Render images in order. */
   for (i=0; i<array_size(bkg_arr); i++) {
      bkg = &bkg_arr[i];

      cam_getPos( &px, &py );
      z = cam_getZoom();

//      x  = (bkg->x - px * bkg->move - bkg->scale*bkg->image->sw/2.)*z;
//      y  = (bkg->y - py * bkg->move - bkg->scale*bkg->image->sh/2.)*z;

      x  = (bkg->x - px * bkg->move - bkg->scale*bkg->image->sw/2.)*z;
      y  = (bkg->y - py * bkg->move - bkg->scale*bkg->image->sh/2.)*z;

      xs = x + SCREEN_W/2.;
      ys = y + SCREEN_H/2.;

      z *= bkg->scale;
      gl_blitScale( bkg->image, xs, ys,
            z*bkg->image->sw, z*bkg->image->sh, &bkg->col );
   }
}


/**
 * @brief Creates a background Lua state from a script.
 */
static nlua_env background_create( const char *name )
{
   uint32_t bufsize;
   char path[PATH_MAX];
   char *buf;
   nlua_env env;

   /* Create file name. */
   nsnprintf( path, sizeof(path), "dat/bkg/%s.lua", name );

   /* Create the Lua env. */
   env = nlua_newEnv(1);
   nlua_loadStandard(env);
   nlua_loadTex(env);
   nlua_loadCol(env);
   nlua_loadBackground(env);

   /* Open file. */
   buf = ndata_read( path, &bufsize );
   if (buf == NULL) {
      WARN("Default background script '%s' not found.", path);
      nlua_freeEnv(env);
      return LUA_NOREF;
   }

   /* Load file. */
   if (nlua_dobufenv(env, buf, bufsize, path) != 0) {
      WARN("Error loading background file: %s\n"
            "%s\n"
            "Most likely Lua file has improper syntax, please check",
            path, lua_tostring(naevL,-1));
      free(buf);
      nlua_freeEnv(env);
      return LUA_NOREF;
   }
   free(buf);

   return env;
}


/**
 * @brief Initializes the background system.
 */
int background_init (void)
{
   /* Load Lua. */
   bkg_def_env = background_create( "default" );
   return 0;
}


/**
 * @brief Loads a background script by name.
 */
int background_load( const char *name )
{
   int ret;
   nlua_env env;
   const char *err;

   /* Free if exists. */
   background_clearCurrent();

   /* Load default. */
   if (name == NULL)
      bkg_cur_env = bkg_def_env;
   /* Load new script. */
   else
      bkg_cur_env = background_create( name );

   /* Comfort. */
   env = bkg_cur_env;
   if (env == LUA_NOREF)
      return -1;

   /* Run Lua. */
   nlua_getenv(env,"background");
   ret = nlua_pcall(env, 0, 0);
   if (ret != 0) { /* error has occurred */
      err = (lua_isstring(naevL,-1)) ? lua_tostring(naevL,-1) : NULL;
      WARN("Background -> 'background' : %s",
            (err) ? err : "unknown error");
      lua_pop(naevL, 1);
   }
   return ret;
}


/**
 * @brief Destroys the current running background script.
 */
static void background_clearCurrent (void)
{
   if (bkg_cur_env != bkg_def_env) {
      if (bkg_cur_env != LUA_NOREF)
         nlua_freeEnv( bkg_cur_env );
   }
   bkg_cur_env = LUA_NOREF;
}


/**
 * @brief Cleans up the background stuff.
 */
void background_clear (void)
{
   /* Destroy current background script. */
   background_clearCurrent();

   /* Clear the backgrounds. */
   background_clearImgArr( &bkg_image_arr_bk );
   background_clearImgArr( &bkg_image_arr_ft );
}


/**
 * @brief Clears a background image array.
 *
 *    @param arr Array to clear.
 */
static void background_clearImgArr( background_image_t **arr )
{
   int i;
   background_image_t *bkg;

   /* Must have an image array created. */
   if (*arr == NULL)
      return;

   for (i=0; i<array_size(*arr); i++) {
      bkg = &((*arr)[i]);
      gl_freeTexture( bkg->image );
   }

   /* Erase it all. */
   array_erase( arr, &(*arr)[0], &(*arr)[ array_size(*arr) ] );
}


/**
 * @brief Cleans up and frees memory after the backgrounds.
 */
void background_free (void)
{
   /* Free the Lua. */
   background_clear();
   if (bkg_def_env != LUA_NOREF)
      nlua_freeEnv( bkg_def_env );
   bkg_def_env = LUA_NOREF;

   /* Free the images. */
   if (bkg_image_arr_ft != NULL) {
      array_free( bkg_image_arr_ft );
      bkg_image_arr_ft = NULL;
   }
   if (bkg_image_arr_bk != NULL) {
      array_free( bkg_image_arr_bk );
      bkg_image_arr_bk = NULL;
   }

   /* Free the Lua. */
   if (bkg_cur_env != LUA_NOREF)
      nlua_freeEnv( bkg_cur_env );
   bkg_cur_env = LUA_NOREF;

   /* Destroy VBOs. */
   if (star_vertexVBO_small != NULL) {
      gl_vboDestroy( star_vertexVBO_small );
      star_vertexVBO_small = NULL;
   }
   if (star_colourVBO_small != NULL) {
      gl_vboDestroy( star_colourVBO_small );
      star_colourVBO_small = NULL;
   }

   if (star_vertexVBO_med != NULL) {
	   gl_vboDestroy( star_vertexVBO_med );
	   star_vertexVBO_med = NULL;
   }
   if (star_colourVBO_med != NULL) {
	   gl_vboDestroy( star_colourVBO_med );
	   star_colourVBO_med = NULL;
   }

   if (star_vertexVBO_large != NULL) {
	   gl_vboDestroy( star_vertexVBO_large );
	   star_vertexVBO_large = NULL;
   }
   if (star_colourVBO_large != NULL) {
	   gl_vboDestroy( star_colourVBO_large );
	   star_colourVBO_large = NULL;
   }

   /* Free the stars. */
   if (star_vertex != NULL) {
      free(star_vertex);
      star_vertex = NULL;
   }
   if (star_colour != NULL) {
      free(star_colour);
      star_colour = NULL;
   }
   if (star_original_pos != NULL) {
	   free(star_original_pos);
	   star_original_pos = NULL;
   }
   if (star_moves != NULL) {
	   free(star_moves);
	   star_moves = NULL;
   }
   nstars = 0;
   mstars = 0;
}

