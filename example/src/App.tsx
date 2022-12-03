import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import HexagonImage from '../../dist';

export default function App() {
  const imgSource={ uri: "https://develop.watchbeem.com/profile_avatars/c5f9c093-3166-47e9-b83e-84f6d72c7151/avatar.jpg?1669199370556.498",borderColor:"#FFC901",borderWidth:50,cornerRadius:100 }

  return (
    <View style={styles.container}>
      <HexagonImage
        style={styles.avatar}
        source={imgSource}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatar: {
    height: 300,
    width: 300,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
