import React, { Component } from 'react';
import { BrowserRouter, Route } from "react-router-dom";
import _ from 'lodash';
import HeaderBar from "./lib/header-bar.js"

import styled, { ThemeProvider, createGlobalStyle } from 'styled-components';

import light from './themes/light';
import dark from './themes/dark';

import { Text, Box } from '@tlon/indigo-react';

import { store } from '../store';

export class Root extends Component {
  constructor(props) {
    super(props);
    this.state = {
      dark: false,
      data: undefined,
    };
    this.updateTheme = this.updateTheme.bind(this);
  }

  updateTheme(updateTheme) {
    this.setState({ dark: updateTheme });
  }

  componentDidMount() {
    this.themeWatcher = window.matchMedia('(prefers-color-scheme: dark)');
    this.setState({ dark: this.themeWatcher.matches });
    this.themeWatcher.addListener(this.updateTheme);
    store.setStateHandler(data => this.setState({ data }));
  }

  render() {
    const { data } = this.state;

    return (
      <BrowserRouter>
        <ThemeProvider theme={this.state.dark ? dark : light}>
        <Box display='flex' flexDirection='column' position='absolute' backgroundColor='white' height='100%' width='100%' px={[0,4]} pb={[0,4]}>
        <HeaderBar/>
        <Route exact path="/~pokedex" render={ () => {
          return (
            <Box height='100%' p='4' display='flex' flexDirection='column' borderWidth={['none', '1px']} borderStyle="solid" borderColor="washedGray">
              <Text fontSize='1'>Pokédex</Text>
              {data && <img src={data['sprite']} width="100" height="100" />}
            </Box>
          )}}
        />
        </Box>
        </ThemeProvider>
      </BrowserRouter>
    )
  }
}
