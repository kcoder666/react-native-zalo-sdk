/**
 * Sample Zalo SDK App
 * https://github.com/khoatrangeek/react-native-zalo-sdk
 *
 * @format
 * @flow
 */

import React from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  Button,
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';

import RNZalo from 'rn-zalo-sdk';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      profile: {},
    };
  }

  onLoginPress = async () => {
    const oauthCode = await RNZalo.login();
    console.log(`Oauth code: ${oauthCode}`);
    const profileData = await RNZalo.getProfile();
    console.log(`Profile: ${JSON.stringify(profileData)}`);
    this.setState({profile: profileData});
  };

  render() {
    const {profile} = this.state;

    return (
      <>
        <StatusBar barStyle="dark-content" />
        <SafeAreaView>
          <ScrollView
            contentInsetAdjustmentBehavior="automatic"
            style={styles.scrollView}>
            <View style={styles.body}>
              <Button title="Login via Zalo" onPress={this.onLoginPress} />
              {!!profile && (
                <>
                  <Text>ID: {profile.id}</Text>
                  <Text>Name: {profile.name}</Text>
                </>
              )}
            </View>
          </ScrollView>
        </SafeAreaView>
      </>
    );
  }
}

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
  },
  body: {
    backgroundColor: Colors.white,
  },
});

export default App;
