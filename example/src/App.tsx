import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { HexagonView } from 'react-native-hexagon';

export default function App() {
  return (
    <View style={styles.container}>
      <HexagonView
        src="https://picsum.photos/200/300.jpg"
        borderColor="#32a852"
        borderWidth={4}
        cornerRadius={7}
        style={styles.box}
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
  box: {
    width: 24,
    height: 24,
    marginVertical: 20,
  },
});
