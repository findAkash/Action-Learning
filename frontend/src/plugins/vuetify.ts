import 'vuetify/styles';
import { createVuetify } from 'vuetify';
import { mdi } from 'vuetify/iconsets/mdi';
import { VCard } from 'vuetify/components/VCard';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';

export default createVuetify({
    components,
    directives,
    icons: {
        defaultSet: 'mdi',
        sets: { mdi },
    },
    theme: {
        defaultTheme: 'customTheme',
        themes: {
            customTheme: {
                colors: {
                background: '#FFFFF0', // Ivory white
                primary: '#6200ea', // Purple
                secondary: '#b00020', // Red
                gradient: 'linear-gradient(90deg, #6200ea, #b00020)', // Gradient from purple to red
                },
            },
        },
    },
});
