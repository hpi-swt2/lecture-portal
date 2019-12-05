import React from 'react';
import QuestionsForm from '../Questions';
import renderer from 'react-test-renderer';

test('Questions renders correctly.', () => {
    const component = renderer.create(
        <Questions />,
    );
    let tree = component.toJSON();
    expect(tree).toMatchSnapshot();
});
