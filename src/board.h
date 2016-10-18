/*
 * See Licensing and Copyright notice in naev.h
 */


#ifndef BOARD_H
#  define BOARD_H


#include "pilot.h"

int player_isBoarded (void);
void player_board (void);
void board_unboard (void);
int pilot_board( Pilot *p );
void pilot_boardComplete( Pilot *p );
void board_exit( unsigned int wdw, char* str );
void board_startLoot( unsigned int wid, char* str );
void board_listUpdate( unsigned int wid, char* str );
void board_listUpdateSelected( unsigned int wid, char* str );
void board_take( unsigned int wdw, char* str );
void board_remove( unsigned int wdw, char* str );

#endif
