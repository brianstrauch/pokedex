import React from 'react';

export function pokedexTile() {
  return (
    <div className={"w-100 h-100 relative bg-white bg-gray0-d ba b--black b--gray1-d"}>
      <a className="w-100 h-100 db bn" href="/~pokedex">
        <p className="black white-d f9 absolute" style={{ left: 8, top: 8 }}>
           Pokédex
        </p>
        <img className="absolute invert-d" src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png" />
      </a>
    </div>
  )
}

window.pokedexTile = pokedexTile;
