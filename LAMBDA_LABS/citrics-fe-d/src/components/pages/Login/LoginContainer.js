import React, { useEffect } from 'react';
import OktaSignIn from '@okta/okta-signin-widget';
import '@okta/okta-signin-widget/dist/css/okta-sign-in.min.css';

import { config } from '../../../utils/oktaConfig';

import logo from '../../../assets/Citrics Icon.svg';

const LoginContainer = () => {
  useEffect(() => {
    const { pkce, issuer, clientId, redirectUri, scopes } = config;
    // destructure your config so that you can pass it into the required fields in your widget.
    const widget = new OktaSignIn({
      baseUrl: issuer ? issuer.split('/oauth2')[0] : '',
      clientId,
      redirectUri,
      registration: {
        // there is more we can do to handle some errors here.
      },
      features: { registration: false },
      // turning this feature on allows your widget to use Okta for user registration
      logo: logo,
      logoText: 'Citrics Logo',
      colors: {
        brand: '#d35540',
      },
      // add your custom logo to your signing/register widget here.
      i18n: {
        en: {
          'primaryauth.title': 'Welcome to Citrics',
          'primaryauth.submit': 'Login',
          // change title for your app
        },
      },
      authParams: {
        pkce,
        issuer,
        display: 'page',
        scopes,
      },
      helpLinks: {
        custom: [
          {
            text: 'Sign up instead?',
            href: '',
            target: '_blank',
          },
        ],
      },
    });

    widget.renderEl(
      { el: '#sign-in-widget' },
      () => {
        /**
         * In this flow, the success handler will not be called because we redirect
         * to the Okta org for the authentication workflow.
         */
      },
      err => {
        throw err;
      }
    );
  }, []);

  return <div id="sign-in-widget" />;
};

export default LoginContainer;
