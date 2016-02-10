/*
 * See Licensing and Copyright notice in naev.h
 */




#ifndef COLLISION_H
#  define COLLISION_H


#include "opengl.h"
#include "physics.h"


/* Returns 1 if collision is detected */
int CollideSprite( const glTexture* at, const int asx, const int asy, const Vector2d* ap,
      const glTexture* bt, const int bsx, const int bsy, const Vector2d* bp,
      Vector2d* crash);
int CollideLineLine( double s1x, double s1y, double e1x, double e1y,
      double s2x, double s2y, double e2x, double e2y, Vector2d* crash );
int CollideLineSprite( const Vector2d* ap, double ad, double al,
      const glTexture* bt, const int bsx, const int bsy, const Vector2d* bp,
      Vector2d crash[2]);


#endif /* COLLISION_H */
