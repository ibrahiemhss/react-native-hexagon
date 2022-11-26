import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { HexagonView } from 'react-native-hexagon';

export default function App() {
  return (
    <View style={styles.container}>
      <HexagonView
        src="https://develop.watchbeem.com/profile_avatars/c5f9c093-3166-47e9-b83e-84f6d72c7151/avatar.jpg?1669199370556.498"
        borderColor="#FFC901"
        borderWidth={6}
        cornerRadius={6}
        width={32}
        height={32}
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
});
